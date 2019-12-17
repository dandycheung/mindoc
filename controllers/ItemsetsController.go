package controllers

import (
	"strconv"

	"github.com/lifei6671/mindoc/conf"
	"github.com/lifei6671/mindoc/models"
	"github.com/astaxie/beego/orm"
	"github.com/lifei6671/mindoc/utils/pagination"
	"github.com/astaxie/beego"
)

type ItemsetsController struct {
	BaseController
}

func (c *ItemsetsController) Prepare() {
	c.BaseController.Prepare()

	// 如果没有开启你们访问则跳转到登录
	if !c.EnableAnonymous && c.Member == nil {
		c.Redirect(conf.URLFor("AccountController.Login"), 302)
		return
	}
}

func (c *ItemsetsController) Index() {
	c.Prepare()
	c.TplName = "items/index.tpl"

	pageSize := 18
	pageIndex, _ := c.GetInt("page", 0)

	items, totalCount, err := models.NewItemsets().FindToPager(pageIndex, pageSize)
	if err != nil && err != orm.ErrNoRows {
		c.ShowErrorPage(500, err.Error())
	}

	c.Data["TotalPages"] = pageIndex

	if err == orm.ErrNoRows || len(items) <= 0 {
		c.Data["Lists"] = items
		c.Data["PageHtml"] = ""
		return
	}

	if totalCount > 0 {
		pager := pagination.NewPagination(c.Ctx.Request, totalCount, pageSize, c.BaseUrl())
		c.Data["PageHtml"] = pager.HtmlPages()
	} else {
		c.Data["PageHtml"] = ""
	}

	c.Data["Lists"] = items
}

func (c *ItemsetsController) List() {
	c.Prepare()
	c.TplName = "items/list.tpl"

	pageSize := 18
	pageIndex, _ := c.GetInt("page", 1)

	itemKey := c.Ctx.Input.Param(":key")
	if itemKey == "" {
		c.Abort("404")
	}

	item, err := models.NewItemsets().FindFirst(itemKey)
	if err != nil {
		if err == orm.ErrNoRows {
			c.Abort("404")
		} else {
			beego.Error(err)
			c.Abort("500")
		}
	}

	memberId := 0
	if c.Member != nil {
		memberId = c.Member.MemberId
	}

	searchResult, totalCount, err := models.NewItemsets().FindItemsetsByItemKey(itemKey, pageIndex, pageSize, memberId)
	if err != nil && err != orm.ErrNoRows {
		c.ShowErrorPage(500, "查询文档列表时出错")
	}

	if totalCount > 0 {
		pager := pagination.NewPagination(c.Ctx.Request, totalCount, pageSize, c.BaseUrl())
		c.Data["PageHtml"] = pager.HtmlPages()
	} else {
		c.Data["PageHtml"] = ""
	}

	c.Data["Lists"] = searchResult
	c.Data["Model"] = item
}

func (c *ItemsetsController) HomeList() {
	c.TplName = "items/home_list.tpl"

	pageSize := 12
	pageIndex, _ := c.GetInt("page", 1)

	memberId := 0
	if c.Member != nil {
		memberId = c.Member.MemberId
	}

	itemId := c.Ctx.Input.Param(":id")
	itemIdInt, _ := strconv.Atoi(itemId)
	item, _ := models.NewItemsets().First(itemIdInt)
	searchResult, _, _ := models.NewItemsets().FindItemsetsByItemKey(item.ItemKey, pageIndex, pageSize, memberId)
	c.Data["Lists"] = searchResult
}
