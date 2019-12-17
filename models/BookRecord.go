package models

import (
	"time"

	"github.com/astaxie/beego/orm"
	"github.com/lifei6671/mindoc/conf"
)

type BookRecord struct {
	RecordId   int       `orm:"column(record_id);pk;auto;unique" json:"record_id"`
	BookId     int       `orm:"column(book_id);type(int)" json:"book_id"`
	MemberId   int       `orm:"column(member_id);type(int)" json:"member_id"`
	Count      int       `orm:"column(count);type(int)" json:"count"`
	ModifyTime time.Time `orm:"column(modify_time);type(datetime);auto_now" json:"modify_time"`
}

// 获取对应数据库表名
func (m *BookRecord) TableName() string {
	return "book_records"
}

// 获取数据使用的引擎
func (m *BookRecord) TableEngine() string {
	return "INNODB"
}

func (m *BookRecord) TableNameWithPrefix() string {
	return conf.GetDatabasePrefix() + m.TableName()
}

func NewBookRecord() *BookRecord {
	return &BookRecord{}
}

func (m *BookRecord) Find(id int) (*BookRecord, error) {
	o := orm.NewOrm()
	err := o.QueryTable(m.TableNameWithPrefix()).Filter("record_id", id).One(m)
	return m, err
}

func (m *BookRecord) FindByMemberBookId(bookId int, memberId int) (*BookRecord, error) {
	o := orm.NewOrm()
	err := o.QueryTable(m.TableNameWithPrefix()).Filter("book_id", bookId).Filter("member_id", memberId).One(m)
	return m, err
}

func (m *BookRecord) FindByMemberId(memberId int, notBookIds []int, offset int, limt int) ([]*BookRecord, error) {
	o := orm.NewOrm()
	cond := orm.NewCondition().And("member_id", memberId)
	if len(notBookIds) > 0 {
		cond = cond.AndNot("book_id__in", notBookIds)
	}

	var records []*BookRecord
	_, err := o.QueryTable(m.TableNameWithPrefix()).SetCond(cond).OrderBy("-count").Limit(limt, offset).All(&records)

	return records, err
}

func (m *BookRecord) InsertOrUpdate() (record *BookRecord, err error) {
	o := orm.NewOrm()

	if m.RecordId > 0 {
		_, err = o.Update(m)
	} else {
		_, err = o.Insert(m)
	}

	record = m
	return
}

func (m *BookRecord) IncrByCount(bookId int, memberId int) (record *BookRecord, err error) {
	record, err = m.FindByMemberBookId(bookId, memberId)
	if err != nil {
		record.BookId = bookId
		record.MemberId = memberId
		record.Count = 1
	} else {
		record.Count = record.Count + 1
	}

	record, err = record.InsertOrUpdate()
	return
}

func (m *BookRecord) DeleteByBookId(bookId int) error {
	o := orm.NewOrm()
	_, err := o.QueryTable(m.TableNameWithPrefix()).Filter("book_id", bookId).Delete()
	return err
}
