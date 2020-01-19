package controllers

import (
	"math"
	"net/url"
	"sort"
	"strconv"

	"github.com/astaxie/beego"
	"github.com/lifei6671/mindoc/conf"
	"github.com/lifei6671/mindoc/models"
	"github.com/lifei6671/mindoc/utils/pagination"
)

type HomeController struct {
	BaseController
}

type ItemData struct {
	Item       *models.Itemsets
	Books      []*models.BookResult
	BookCount  int
	TotalPages int
	Pages      []int
}

func (c *HomeController) Prepare() {
	c.BaseController.Prepare()

	// 如果没有开启匿名访问，则跳转到登录页面
	if !c.EnableAnonymous && c.Member == nil {
		c.Redirect(conf.URLFor("AccountController.Login") + "?url=" + url.PathEscape(conf.BaseUrl + c.Ctx.Request.URL.RequestURI()), 302)
	}
}

func (c *HomeController) Index() {
	c.Prepare()
	c.TplName = "home/index.tpl"

	pageIndex, _ := c.GetInt("page", 1)
	pageSize := 18

	memberId := 0

	if c.Member != nil {
		memberId = c.Member.MemberId
	}

	books, totalCount, err := models.NewBook().FindForHomeToPager(pageIndex, pageSize, memberId)
	if err != nil {
		beego.Error(err)
		c.Abort("500")
	}

	if totalCount > 0 {
		pager := pagination.NewPagination(c.Ctx.Request, totalCount, pageSize, c.BaseUrl())
		c.Data["PageHtml"] = pager.HtmlPages()
	} else {
		c.Data["PageHtml"] = ""
	}

	c.Data["TotalPages"] = int(math.Ceil(float64(totalCount) / float64(pageSize)))
	c.Data["Lists"] = books

	pinBookIds := []int{}
	pins, err := models.NewBookPin().FindByMemberId(memberId)
	for _, pin := range pins {
		pinBookIds = append(pinBookIds, pin.BookId)
	}

	pinBooks, err := models.NewBook().FindByIds(pinBookIds)

	recordBookIds := []int{}
	records, err := models.NewBookRecord().FindByMemberId(memberId, pinBookIds, 0, 10)
	for _, record := range records {
		recordBookIds = append(recordBookIds, record.BookId)
	}

	recordBooks, err := models.NewBook().FindByIds(recordBookIds)

	sort.Slice(pinBooks, func(i, j int) bool {
		iBookId := pinBooks[i].BookId
		jBookId := pinBooks[j].BookId
		iIndex := 0
		jIndex := 0

		for index, bookId := range pinBookIds {
			if bookId == iBookId {
				iIndex = index
			}

			if bookId == jBookId {
				jIndex = index
			}
		}

		if iIndex < jIndex {
			return true
		} else {
			return false
		}
	})

	sort.Slice(recordBooks, func(i, j int) bool {
		iBookId := recordBooks[i].BookId
		jBookId := recordBooks[j].BookId
		iIndex := 0
		jIndex := 0

		for index, bookId := range recordBookIds {
			if bookId == iBookId {
				iIndex = index
			}

			if bookId == jBookId {
				jIndex = index
			}
		}

		if iIndex < jIndex {
			return true
		} else {
			return false
		}
	})

	c.Data["memberId"] = memberId
	c.Data["PinLists"] = pinBooks
	c.Data["RecordLists"] = recordBooks
	if len(pinBooks) > 0 || len(recordBooks) > 0 {
		c.Data["RecentShow"] = true
	} else {
		c.Data["RecentShow"] = false
	}

	var itemDatas []ItemData

	pageSize = 12
	items, _, _ := models.NewItemsets().FindAll()
	for _, item := range items {
		itemBooks, itemBookCount, _ := models.NewItemsets().FindItemsetsByItemKey(item.ItemKey, 1, pageSize, memberId)
		ItemTotalPages := int(math.Ceil(float64(itemBookCount) / float64(pageSize)))

		ItemPages := []int{}
		for page := 1; page <= ItemTotalPages; page++ {
			ItemPages = append(ItemPages, page)
		}

		itemData := ItemData{Item: item, Books: itemBooks, BookCount: itemBookCount, TotalPages: ItemTotalPages, Pages: ItemPages}
		itemDatas = append(itemDatas, itemData)
	}

	c.Data["itemDatas"] = itemDatas

	cookieKey := "indexOnlyPin_" + strconv.Itoa(memberId)
	indexOnlyPin := c.Ctx.GetCookie(cookieKey)

	if len(indexOnlyPin) > 0 {
		c.Data["indexOnlyChecked"] = true
	} else {
		c.Data["indexOnlyChecked"] = false
	}
}
