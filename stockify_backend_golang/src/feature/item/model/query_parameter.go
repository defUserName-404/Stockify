package model

type ItemFilterParams struct {
	Search       string
	DeviceType   *DeviceType
	AssetStatus  *AssetStatus
	AssignedToID *uint64
	SortBy       string
	SortOrder    string
}
