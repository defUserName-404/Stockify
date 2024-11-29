package model

import (
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	ID          uint64 `gorm:"primaryKey;autoIncrement"`
	UserName    string
	Designation *string
	SapId       *string
	IpPhone     *string
	RoomNo      *string
	Floor       *string
}
