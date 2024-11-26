package model

type AssetStatus string

const (
	ACTIVE   AssetStatus = "Active"
	INACTIVE AssetStatus = "Inactive"
	DISPOSED AssetStatus = "Disposed"
)
