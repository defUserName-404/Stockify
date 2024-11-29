package model

import (
	"fmt"
	"gorm.io/gorm"
	"stockify_backend_golang/src/feature/user/model"
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
	return fmt.Sprintf("Item{ID: %s, AssetNo: %s, ModelNo: %s, SerialNo: %s, DeviceType: %s, ReceivedDate: %s, WarrantyDate: %s, AssetStatus: %s, HostName: %s, IpPort: %s, MacAddress: %s, OsVersion: %s, FacePlateName: %s, SwitchPort: %s, SwitchIpAddress: %s, IsPasswordProtected: %t, AssignedTo: %s}",
		i.ID, i.AssetNo, i.ModelNo, i.SerialNo, i.DeviceType, i.ReceivedDate, i.WarrantyDate, i.AssetStatus, i.HostName, i.IpPort, i.MacAddress, i.OsVersion, i.FacePlateName, i.SwitchPort, i.SwitchIpAddress, i.IsPasswordProtected, i.AssignedTo)
}
