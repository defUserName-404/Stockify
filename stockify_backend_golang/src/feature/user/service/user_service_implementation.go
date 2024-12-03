package service

import (
	"stockify_backend_golang/src/feature/user/model"
	"stockify_backend_golang/src/feature/user/repository"
)

type userService struct {
	repo repository.UserRepository
}

func UserServiceImplementation(repo repository.UserRepository) UserService {
	return &userService{repo: repo}
}

func (s *userService) AddUser(user model.User) {
	s.repo.AddUser(user)
}

func (s *userService) GetAllUsers() []model.User {
	return s.repo.GetAllUsers()
}

func (s *userService) GetUserById(id uint64) model.User {
	return s.repo.GetUserById(id)
}

func (s *userService) UpdateUser(user model.User) {
	s.repo.UpdateUser(user)
}

func (s *userService) DeleteUserById(id uint64) {
	s.repo.DeleteUserById(id)
}

func (s *userService) GetFilteredUsers(params model.UserQueryParams) ([]model.User, error) {
	return s.repo.GetFilteredUsers(params)
}
