package model

import (
	"fmt"
	"gorm.io/gorm"
	"strings"
)

type User struct {
	gorm.Model
	ID          uint64  `gorm:"primaryKey;autoIncrement" json:"ID"`
	UserName    string  `json:"userName"`
	Designation *string `json:"designation,omitempty"`
	SapId       *string `json:"sapId,omitempty"`
	IpPhone     *string `json:"ipPhone,omitempty"`
	RoomNo      *string `json:"roomNo,omitempty"`
	Floor       *string `json:"floor,omitempty"`
}

func (u *User) String() string {
	var sb strings.Builder
	sb.WriteString(fmt.Sprintf("User{ID: %d, UserName: %s", u.ID, u.UserName))
	if u.Designation != nil {
		sb.WriteString(fmt.Sprintf(", %s", *u.Designation))
	}
	if u.SapId != nil {
		sb.WriteString(fmt.Sprintf(", %s", *u.SapId))
	}
	if u.RoomNo != nil {
		sb.WriteString(fmt.Sprintf(", %s", *u.RoomNo))
	}
	if u.Floor != nil {
		sb.WriteString(fmt.Sprintf(", %s", *u.Floor))
	}
	sb.WriteString("}")
	return sb.String()
}
