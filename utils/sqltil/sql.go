package sqltil

import "strings"

// 转义 like 语法的 %_ 符号
func EscapeLike(keyword string) string {
	return strings.Replace(strings.Replace(keyword, "_", "\\_", -1), "%", "\\%", -1)
}
