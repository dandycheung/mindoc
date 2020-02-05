<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>{{.SITE_NAME}} - Powered by MinDoc</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="renderer" content="webkit">
    <meta name="author" content="Minho" />
    <meta name="site" content="https://www.iminho.me" />
    <meta name="keywords" content="MinDoc,文档在线管理系统,WIKI,wiki,wiki在线,文档在线管理,接口文档在线管理,接口文档管理">
    <meta name="description" content="MinDoc文档在线管理系统 {{.site_description}}">
    <!-- Bootstrap -->
    <link href="{{cdncss "/static/bootstrap/css/bootstrap.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/font-awesome/css/font-awesome.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/css/main.css" "version"}}" rel="stylesheet">

</head>
<body>
<style>
.su-label {
  margin: 20px 20px 0 0;
  padding-left: 6px;
  display: inline-block
}
.su-radio {
  display: none
}
.su-radioInput {
  background-color: #fff;
  border:1px solid rgba(0, 0, 0, 0.15);
  border-radius: 100%;
  display: inline-block;
  height: 18px;
  margin-right: 5px;
  margin-top: -1px;
  vertical-align: middle;
  width: 18px;
  line-height: 1
}
.su-radio:checked + .su-radioInput:after {
  background-color: #57ad68;
  border-radius: 100%;
  content: "";
  display: inline-block;
  height: 12px;
  margin: 2px;
  width: 12px
}
.su-checkbox.su-radioInput,.su-radio:checked + .su-checkbox.su-radioInput:after {
  border-radius: 0
}
</style>

<div class="manual-reader manual-container">
    {{template "widgets/header.tpl" .}}
    <div class="container manual-body">
        <!--
        <div class="row">
             <div class="manual-list">
                {{range $index,$item := .Lists}}
                    <div class="list-item">
                        <dl class="manual-item-standard">
                            <dt>
                                <a href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" title="{{$item.BookName}}-{{$item.CreateName}}" target="_blank">
                                    <img src="{{cdnimg $item.Cover}}" class="cover" alt="{{$item.BookName}}-{{$item.CreateName}}" onerror="this.src='{{cdnimg "static/images/book.jpg"}}';">
                                </a>
                            </dt>
                            <dd>
                                <a href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" class="name" title="{{$item.BookName}}-{{$item.CreateName}}" target="_blank">{{$item.BookName}}</a>
                            </dd>
                            <dd>
                            <span class="author">
                                <b class="text">作者</b>
                                <b class="text">-</b>
                                <b class="text">{{if eq $item.RealName "" }}{{$item.CreateName}}{{else}}{{$item.RealName}}{{end}}</b>
                            </span>
                            </dd>
                        </dl>
                    </div>
                {{else}}
                    <div class="text-center" style="height: 200px;margin: 100px;font-size: 28px;">暂无项目</div>
                {{end}}
                <div class="clearfix"></div>
            </div>
            <nav class="pagination-container">
                {{if gt .TotalPages 1}}
                {{.PageHtml}}
                {{end}}
                <div class="clearfix"></div>
            </nav>
        </div>
        -->

        <div class="row" style="margin-top:20px;">
            <div class="item-head">
                <strong class="title">快速访问</strong>
                <label class="su-label">
                  <input class="su-radio" type="checkbox" id="onlyPin" {{if .indexOnlyChecked}}checked{{end}} onclick="toggleOnlyPin()">
                  <span class="su-checkbox su-radioInput"></span>仅显示置顶项
                </label>
            </div>
            <div class="manual-list">

                <span id="pin-lists">
                {{range $index,$item := .PinLists}}
                    <div class="list-item pin-tag" id="pin_{{$item.Identify}}" >
                        <dl class="manual-item-standard">
                            <dt style="position:relative;">
                                <div title="取消置顶" onclick="unpin('{{$item.Identify}}')" style="cursor:pointer;position:absolute;top:5px;left:10px;z-index:100;width:60px;height:30px;color:#f0ad4e;">
                                    <i class="fa fa-heart"></i>
                                </div>
                                <a href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" title="{{$item.BookName}}" target="_blank">
                                    <img src="{{cdnimg $item.Cover}}" class="cover" alt="{{$item.BookName}}" onerror="this.src='{{cdnimg "static/images/book.jpg"}}';">
                                </a>
                            </dt>
                            <dd>
                                <a href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" class="name" title="{{$item.BookName}}" target="_blank"><strong>{{$item.BookName}}</strong></a>
                            </dd>
                        </dl>
                    </div>
                {{end}}
                </span>

                <span id="record-lists"  {{if .indexOnlyChecked}} style="display:none;" {{end}}>
                {{range $index,$item := .RecordLists}}
                    <div class="list-item record-tag" id="record_{{$item.Identify}}">
                        <dl class="manual-item-standard">
                            <dt>
                                <a href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" title="{{$item.BookName}}" target="_blank">
                                    <img src="{{cdnimg $item.Cover}}" class="cover" alt="{{$item.BookName}}" onerror="this.src='{{cdnimg "static/images/book.jpg"}}';">
                                </a>
                            </dt>
                            <dd>
                                <a href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" class="name" title="{{$item.BookName}}" target="_blank">{{$item.BookName}}</a>
                            </dd>
                        </dl>
                    </div>
                {{end}}
                </span>

                <div class="clearfix"></div>
            </div>
        </div>

        <div class="row" style="margin-top:20px;"></div>

        {{range $index, $itemData := .itemDatas}}
        <div class="row" >
            <div class="item-head">
                <strong class="title">{{$itemData.Item.ItemName}}</strong>
            </div>
            <div class="manual-list" id="ItemContent_{{$itemData.Item.ItemId}}" >
                {{range $index,$item := $itemData.Books}}
                    <div class="list-item" id="item_{{$item.Identify}}">
                        <dl class="manual-item-standard">
                            <dt style="position:relative;">
                                <div title="置顶" id="item_pin_{{$item.Identify}}" onclick="pin('{{$item.Identify}}')"  style="cursor:pointer;position:absolute;top:5px;left:10px;z-index:100;width:50px;height:30px;color:#f0ad4e;">
                                    <i class="fa fa-heart-o"></i>
                                </div>
                                <a href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" title="{{$item.BookName}}-{{$item.CreateName}}" target="_blank">
                                    <img id="item_img_{{$item.Identify}}" src="{{cdnimg $item.Cover}}" class="cover" alt="{{$item.BookName}}-{{$item.CreateName}}" onerror="this.src='{{cdnimg "static/images/book.jpg"}}';">
                                </a>
                            </dt>
                            <dd>
                                <a id="item_a_{{$item.Identify}}" href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" class="name" title="{{$item.BookName}}-{{$item.CreateName}}" target="_blank">{{$item.BookName}}</a>
                            </dd>
                            <dd>
                            <span class="author">
                                <b class="text">作者</b>
                                <b class="text">-</b>
                                <b class="text">{{if eq $item.RealName "" }}{{$item.CreateName}}{{else}}{{$item.RealName}}{{end}}</b>
                            </span>
                            </dd>
                        </dl>
                    </div>
                {{else}}
                    <div class="text-center" style="height: 200px;margin: 100px;font-size: 28px;">暂无项目</div>
                {{end}}
                <div class="clearfix"></div>
            </div>
            
            {{if gt $itemData.TotalPages 1}}
            <nav class="pagination-container">
                <ul class="pagination">
                    <li>
                        <a href="javascript:getItemBook({{$itemData.Item.ItemId}}, 1)">首页</a>
                    </li>
                    {{range $index2,$page := $itemData.Pages}}
                    <li id="page_{{$itemData.Item.ItemId}}_{{$page}}" class="page_{{$itemData.Item.ItemId}} {{if eq $page 1}}active{{end}}">
                        <a href="javascript:getItemBook({{$itemData.Item.ItemId}}, {{$page}})">{{$page}}</a>
                    </li>
                    {{end}}
                    <li>
                        <a href="javascript:getItemBook({{$itemData.Item.ItemId}}, {{$itemData.TotalPages}})">末页</a>
                    </li>
                </ul>
                <div class="clearfix"></div>
            </nav>
            {{end}}
        </div>
        {{end}}
    </div>
    {{template "widgets/footer.tpl" .}}
</div>
<script src="{{cdnjs "/static/jquery/1.12.4/jquery.min.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/bootstrap/js/bootstrap.min.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/layer/layer.js"}}" type="text/javascript"></script>
{{.Scripts}}
<script>
    var memberId = "{{.memberId}}";

    $(".pin-tag").each(function() {
        var pinId = $(this).attr('id');
        var id = pinId.slice(4);
        $("#item_pin_" + id).hide();

    });

    function getItemBook(itemId, page)
    {
        var url = '/items/home/' + itemId + '?page=' + page;
        $("#ItemContent_" + itemId).load(url);
        $(".page_" + itemId).removeClass("active")
        $("#page_" + itemId + "_" + page).addClass("active");
    }

    function pin(identify)
    {
        var href = $("#item_a_" + identify).attr("href");
        var bookName = $("#item_a_" + identify).html();
        var imgSrc = $("#item_img_" + identify).attr("src");

        var pinListItemHtml = '<div class="list-item" id="pin_' + identify + '">';
            pinListItemHtml += '<dl class="manual-item-standard">';
            pinListItemHtml += '<dt style="position:relative;">';
            pinListItemHtml += '<div title="取消置顶" onclick="unpin(\'' + identify + '\')"  style="cursor:pointer;position:absolute;top:5px;left:10px;z-index:100;width:60px;height:30px;color:#f0ad4e;"><i class="fa fa-heart"></i></div>';
            pinListItemHtml += '<a href="' + href + '" title="' + bookName + '" target="_blank"><img src="' + imgSrc + '" class="cover" alt="' + bookName + '" onerror="this.src=\'{{cdnimg "static/images/book.jpg"}}\';"></a>';
            pinListItemHtml += '</dt>';
            pinListItemHtml += '<dd><a href="' + href + '" class="name" title="' + bookName + '" target="_blank"><strong>' + bookName + '</strong></a></dd>';
            pinListItemHtml += '</dl></div>';

        $.ajax({
            url: "/book/pin?identify=" + identify,
            type: "GET",
            success: function (res) {
                if (res.errcode === 0) { 
                    $("#item_pin_" + identify).hide();
                    $("#record_" + identify).hide();
                    $("#pin-lists").append(pinListItemHtml);
                    layer.msg('操作成功');
                } else {
                    layer.msg(res.message);
                }
            }
        });
    }

    function unpin(identify)
    {
        $.ajax({
            url: "/book/unpin?identify=" + identify,
            type: "GET",
            success: function (res) {
                if (res.errcode === 0) {
                    $("#item_pin_" + identify).show();
                    $("#record_" + identify).show();
                    $("#pin_" + identify).remove();
                    layer.msg('操作成功');
                } else {
                    layer.msg(res.message);
                }
            }
        });
    }

    function toggleOnlyPin()
    {
        if($("#onlyPin").get(0).checked) {
            setCookie("indexOnlyPin_" + memberId, memberId, 1500);
            $("#record-lists").hide();
        } else {
            delCookie("indexOnlyPin_" + memberId);
            $("#record-lists").show();
        }
    }

    function setCookie(c_name, value, expiredays)
    {
        var exdate = new Date()
        exdate.setDate(exdate.getDate() + expiredays)
        document.cookie = c_name + "=" + escape(value) +
            ((expiredays == null) ? "" : ";expires=" + exdate.toGMTString())
    }

    function getCookie(name)
    { 
        var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");

        if(arr = document.cookie.match(reg))
            return unescape(arr[2]);

        return null;
    }

    function delCookie(name)
    {
        var exp = new Date();
        exp.setTime(exp.getTime() - 1);

        var cval = getCookie(name);
        if(cval != null)
            document.cookie= name + "=" + cval + ";expires=" + exp.toGMTString();
    }
</script>
</body>
</html>
