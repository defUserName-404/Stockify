package model

type WarrantyDateFilterType string

const (
	Day   WarrantyDateFilterType = "day"
	Month WarrantyDateFilterType = "month"
	Year  WarrantyDateFilterType = "year"
)

type ItemFilterParams struct {
	Search                 string
	DeviceType             *DeviceType
	AssetStatus            *AssetStatus
	AssignedToID           *uint64
	WarrantyDate           *int64
	WarrantyDateFilterType *WarrantyDateFilterType
	IsExpiring             bool
	IsExpired              bool
	SortBy                 string
	SortOrder              string
}
