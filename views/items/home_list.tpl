
{{range $index,$item := .Lists}}
    <div class="list-item">
        <dl class="manual-item-standard">
            <dt>
                <a href="{{urlfor "DocumentController.Index" ":key" $item.Identify}}" title="{{$item.BookName}}-{{$item.CreateName}}" target="_blank">
                    <img src="{{cdnimg $item.Cover}}" class="cover" alt="{{$item.BookName}}-{{$item.CreateName}}">
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
    <div class="search-empty">
        <img src="{{cdnimg "/static/images/search_empty.png"}}" class="empty-image">
        <span class="empty-text">暂无项目</span>
    </div>
{{end}}
    <div class="clearfix"></div>
            