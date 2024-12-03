package service

import "stockify_backend_golang/src/feature/user/model"

type UserService interface {
	AddUser(item model.User)
	GetAllUsers() []model.User
	GetUserById(id uint64) model.User
	UpdateUser(User model.User)
	DeleteUserById(id uint64)
	GetFilteredUsers(params model.UserQueryParams) ([]model.User, error)
}
