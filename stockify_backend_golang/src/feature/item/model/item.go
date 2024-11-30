package model

import (
	"fmt"
	"gorm.io/gorm"
	"stockify_backend_golang/src/feature/user/model"
	"strings"
	"time"
)

type Item struct {
	gorm.Model
	ID                  uint64 `gorm:"primaryKey;autoIncrement"`
	AssetNo             string
	ModelNo             string
	DeviceType          DeviceType
	SerialNo            string
	ReceivedDate        *time.Time
	WarrantyDate        time.Time
	AssetStatus         AssetStatus
	HostName            *string
	IpPort              *string
	MacAddress          *string
	OsVersion           *string
	FacePlateName       *string
	SwitchPort          *string
	SwitchIpAddress     *string
	IsPasswordProtected *bool
	AssignedToID        *uint64
	AssignedTo          *model.User `gorm:"foreignKey:AssignedToID"`
}

func (i *Item) String() string {
	var sb strings.Builder

	sb.WriteString(fmt.Sprintf("Item{ID: %d, AssetNo: %s, ModelNo: %s, SerialNo: %s, DeviceType: %s, WarrantyDate: %s, AssetStatus: %s",
		i.ID, i.AssetNo, i.ModelNo, i.SerialNo, i.DeviceType, i.WarrantyDate.Format(time.DateOnly), i.AssetStatus))
	if i.ReceivedDate != nil {
		receivedDate := i.ReceivedDate.Format(time.DateOnly)
		sb.WriteString(fmt.Sprintf(", ReceivedDate: %s", receivedDate))
	}
	if i.HostName != nil {
		sb.WriteString(fmt.Sprintf(", HostName: %s", *i.HostName))
	}
	if i.IpPort != nil {
		sb.WriteString(fmt.Sprintf(", IpPort: %s", *i.IpPort))
	}
	if i.MacAddress != nil {
		sb.WriteString(fmt.Sprintf(", MacAddress: %s", *i.MacAddress))
	}
	if i.OsVersion != nil {
		sb.WriteString(fmt.Sprintf(", OsVersion: %s", *i.OsVersion))
	}
	if i.FacePlateName != nil {
		sb.WriteString(fmt.Sprintf(", FacePlateName: %s", *i.FacePlateName))
	}
	if i.SwitchPort != nil {
		sb.WriteString(fmt.Sprintf(", SwitchPort: %s", *i.SwitchPort))
	}
	if i.SwitchIpAddress != nil {
		sb.WriteString(fmt.Sprintf(", SwitchIpAddress: %s", *i.SwitchIpAddress))
	}
	if i.IsPasswordProtected != nil {
		sb.WriteString(fmt.Sprintf(", IsPasswordProtected: %t", *i.IsPasswordProtected))
	}
	if i.AssignedTo != nil {
		sb.WriteString(fmt.Sprintf(", AssignedTo: %s", i.AssignedTo.UserName))
	}

	sb.WriteString("}")
	return sb.String()
}
