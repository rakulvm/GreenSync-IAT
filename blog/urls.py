from django.urls import path
from .views import (
    PostListView,
    PostDetailView,
    PostCreateView,
    PostUpdateView,
    PostDeleteView,
    UserPostListView
)
from . import views

urlpatterns = [
    path('', views.home, name='blog-home'),
    path('user/<str:username>', views.UserPostListView.as_view(), name='user-posts'),
    path('post/<int:pk>/', views.post_detail, name='post-detail'),
    path('post/new/', views.PostCreateView.as_view(), name='post-create'),
    path('post/<int:pk>/update/', views.PostUpdateView.as_view(), name='post-update'),
    path('post/<int:pk>/delete/', views.PostDeleteView.as_view(), name='post-delete'),
    path('about/', views.about, name='blog-about'),
    path('search/', views.search, name='search'),
]
