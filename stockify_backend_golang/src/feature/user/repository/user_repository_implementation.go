package repository

import (
	"stockify_backend_golang/src/common/db"
	"stockify_backend_golang/src/feature/user/model"
)

func init() {
	err := db.DB.AutoMigrate(&model.User{})
	if err != nil {
		panic("Failed to migrate Item table: " + err.Error())
	}
}

type userRepository struct{}

func UserRepositoryImplementation() UserRepository {
	return &userRepository{}
}

func (r *userRepository) AddUser(user model.User) {
	db.DB.Create(&user)
}

func (r *userRepository) GetAllUsers() []model.User {
	var users []model.User
	db.DB.Find(&users)
	return users
}

func (r *userRepository) GetUserById(id uint64) model.User {
	var user model.User
	db.DB.First(&user, id)
	return user
}

func (r *userRepository) UpdateUser(user model.User) {
	db.DB.Select("IsPasswordProtected").Updates(&user)
}

func (r *userRepository) DeleteUserById(id uint64) {
	var user model.User
	result := db.DB.First(&user, id)
	if result.Error != nil {
		panic("User not found")
	}
	db.DB.Delete(&user)
}
