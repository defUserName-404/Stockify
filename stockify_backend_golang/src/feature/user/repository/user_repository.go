package repository

import (
	"stockify_backend_golang/src/feature/user/model"
)

type UserRepository interface {
	GetAllUsers() []model.User
	GetUserById(id uint64) model.User
	AddUser(item model.User)
	UpdateUser(item model.User)
	DeleteUserById(id uint64)
}
