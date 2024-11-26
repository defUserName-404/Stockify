package service

import (
	"stockify_backend_golang/src/feature/item/model"
	"stockify_backend_golang/src/feature/item/repository"
)

type itemService struct {
	repo repository.ItemRepository
}

func ItemServiceImplementation(repo repository.ItemRepository) ItemService {
	return &itemService{repo: repo}
}

func (s *itemService) AddItem(item model.Item) {
	s.repo.AddItem(item)
}

func (s *itemService) GetAllItems() []model.Item {
	return s.repo.GetAllItems()
}

func (s *itemService) GetItemById(id string) model.Item {
	return s.repo.GetItemById(id)
}

func (s *itemService) UpdateItem(item model.Item) {
	s.repo.UpdateItem(item)
}

func (s *itemService) DeleteItem(item model.Item) {
	s.repo.DeleteItem(item)
}
