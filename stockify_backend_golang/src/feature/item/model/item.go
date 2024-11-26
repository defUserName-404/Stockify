package model

import (
	"fmt"
	"time"
)

type Item struct {
	ID                  string
	AssetNo             string
	ModelNo             string
	DeviceType          DeviceType
	SerialNo            string
	ReceivedDate        time.Time
	WarrantyDate        time.Time
	AssetStatus         AssetStatus
	HostName            string
	IpPort              string
	MacAddress          string
	OsVersion           string
	FacePlateName       string
	SwitchPort          string
	SwitchIpAddress     string
	IsPasswordProtected bool
	AssignedTo          string
}

func (i *Item) String() string {
	return fmt.Sprintf("Item{ID: %s, AssetNo: %s, ModelNo: %s, SerialNo: %s, DeviceType: %s, ReceivedDate: %s, WarrantyDate: %s, AssetStatus: %s, HostName: %s, IpPort: %s, MacAddress: %s, OsVersion: %s, FacePlateName: %s, SwitchPort: %s, SwitchIpAddress: %s, IsPasswordProtected: %t, AssignedTo: %s}",
		i.ID, i.AssetNo, i.ModelNo, i.SerialNo, i.DeviceType, i.ReceivedDate, i.WarrantyDate, i.AssetStatus, i.HostName, i.IpPort, i.MacAddress, i.OsVersion, i.FacePlateName, i.SwitchPort, i.SwitchIpAddress, i.IsPasswordProtected, i.AssignedTo)
}
