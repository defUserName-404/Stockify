package repository

import (
	"log"
	"stockify_backend_golang/src/common/db"
	"stockify_backend_golang/src/feature/user/model"
)

func init() {
	err := db.DB.AutoMigrate(&model.User{})
	if err != nil {
		log.Fatal("Failed to migrate Item table: " + err.Error())
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
	db.DB.Save(&user)
}

func (r *userRepository) DeleteUserById(id uint64) {
	var user model.User
	result := db.DB.First(&user, id)
	if result.Error != nil {
		log.Fatal("User not found")
	}
	db.DB.Delete(&user)
}

func (r *userRepository) GetFilteredUsers(params model.UserQueryParams) ([]model.User, error) {
	database := db.DB.Model(&model.User{})
	// Searching
	if params.Search != "" {
		searchTerm := "%" + params.Search + "%"
		database = database.Where("user_name LIKE ? OR sap_id LIKE ?", searchTerm, searchTerm)
	}
	// Sorting
	sortColumn := map[string]string{
		"user_name": "user_name",
		"sap_id":    "sap_id",
	}[params.SortBy]
	if sortColumn != "" {
		order := "ASC"
		if params.SortOrder == "DESC" {
			order = "DESC"
		}
		database = database.Order(sortColumn + " " + order)
	}
	var users []model.User
	err := database.Find(&users).Error
	if err != nil {
		return nil, err
	}
	return users, nil
}