# blog/forms.py
# blog/forms.py

from django import forms
from .models import Comment

class CommentForm(forms.ModelForm):
    class Meta:
        model = Comment
        fields = ['content']
        widgets = {
            'content': forms.Textarea(attrs={
                'rows': 4,  # Adjust the number of rows
                'cols': 50,  # Adjust the number of columns
                'style': 'resize:none; width: 300px;',  # Set a specific width
                'class': 'form-control'  # Add Bootstrap class for styling
            })}

class ReplyForm(forms.ModelForm):
    class Meta:
        model = Comment
        fields = ['content']
        widgets = {
            'content': forms.Textarea(attrs={
                'rows': 4,  # Adjust the number of rows
                'cols': 50,  # Adjust the number of columns
                'style': 'resize:none; width: 300px;',  # Set a specific width
                'class': 'form-control'  # Add Bootstrap class for styling
            })}
