package models

import (
	"time"

	"github.com/astaxie/beego/orm"
	"github.com/lifei6671/mindoc/conf"
)

type BookPin struct {
	PinId      int       `orm:"column(pin_id);pk;auto;unique" json:"pin_id"`
	BookId     int       `orm:"column(book_id);type(int)" json:"book_id"`
	MemberId   int       `orm:"column(member_id);type(int)" json:"member_id"`
	ModifyTime time.Time `orm:"column(modify_time);type(datetime);auto_now" json:"modify_time"`
}

// 获取对应数据库表名
func (m *BookPin) TableName() string {
	return "book_pins"
}

// 获取数据使用的引擎
func (m *BookPin) TableEngine() string {
	return "INNODB"
}

func (m *BookPin) TableNameWithPrefix() string {
	return conf.GetDatabasePrefix() + m.TableName()
}

func NewBookPin() *BookPin {
	return &BookPin{}
}

func (m *BookPin) Find(id int) (*BookPin, error) {
	o := orm.NewOrm()
	err := o.QueryTable(m.TableNameWithPrefix()).Filter("pin_id", id).One(m)
	return m, err
}

func (m *BookPin) FindByMemberId(memberId int) ([]*BookPin, error) {
	var pins []*BookPin

	o := orm.NewOrm()
	_, err := o.QueryTable(m.TableNameWithPrefix()).Filter("member_id", memberId).OrderBy("pin_id").All(&pins)
	return pins, err
}

func (m *BookPin) CountByMemberBookId(bookId int, memberId int) (int64, error) {
	o := orm.NewOrm()
	count, err := o.QueryTable(m.TableNameWithPrefix()).Filter("member_id", memberId).Filter("book_id", bookId).Count()
	return count, err
}

func (m *BookPin) FindByMemberBookId(bookId int, memberId int) (*BookPin, error) {
	o := orm.NewOrm()
	err := o.QueryTable(m.TableNameWithPrefix()).Filter("member_id", memberId).Filter("book_id", bookId).One(m)
	return m, err
}

func (m *BookPin) Insert() (*BookPin, error) {
	o := orm.NewOrm()
	_, err := o.Insert(m)
	return m, err
}

func (m *BookPin) Delete() error {
	o := orm.NewOrm()
	_, err := o.QueryTable(m.TableNameWithPrefix()).Filter("pin_id", m.PinId).Delete()
	return err
}

func (m *BookPin) DeleteByBookId(bookId int) error {
	o := orm.NewOrm()
	_, err := o.QueryTable(m.TableNameWithPrefix()).Filter("book_id", bookId).Delete()
	return err
}
