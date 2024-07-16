import datetime

from django.contrib.auth.models import User
from django.db import models
from django.db.models import Count
from django.urls import reverse
# from mapbox_location_field.models import LocationField
# from ckeditor_uploader.fields import RichTextUploadingField

class EventCategory(models.Model):
    name = models.CharField(max_length=255, unique=True)
    code = models.CharField(max_length=6, unique=True)
    image = models.ImageField(upload_to='userPortal/static/event_category/')
    created_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='created_user')
    updated_user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='updated_user')
    created_date = models.DateField(auto_now_add=True)
    updated_date = models.DateField(auto_now_add=True)

    def __str__(self):
        return self.name


class Event(models.Model):
    category = models.ForeignKey(EventCategory, on_delete=models.CASCADE)
    name = models.CharField(max_length=255, unique=True)
    uid = models.PositiveIntegerField(unique=True)
    description = models.TextField()
    scheduled_status = models.CharField(max_length=25, choices=[
        ('yet to scheduled', 'Yet to Scheduled'),
        ('scheduled', 'Scheduled')
    ])
    venue = models.CharField(max_length=255)
    start_date = models.DateField()
    end_date = models.DateField()
    location = models.CharField(max_length=255)
    maximum_attende = models.PositiveIntegerField()
    created_user = models.ForeignKey(User, on_delete=models.CASCADE, blank=True, null=True, related_name='event_created_user')
    updated_user = models.ForeignKey(User, on_delete=models.CASCADE, blank=True, null=True, related_name='event_updated_user')
    created_date = models.DateField(auto_now_add=True)
    updated_date = models.DateField(auto_now_add=True)
    status = models.CharField(choices=[
        ('disabled', 'Disabled'),
        ('active', 'Active'),
        ('deleted', 'Deleted'),
        ('time out', 'Time Out'),
        ('completed', 'Completed'),
        ('cancel', 'Cancel')
    ], max_length=10)

    def __str__(self):
        return self.name

    def get_absolute_url(self):
        return reverse('event-list')

    def created_updated(model, request):
        obj = model.objects.latest('pk')
        if obj.created_by is None:
            obj.created_by = request.user
        obj.updated_by = request.user
        obj.save()

    @property
    def registration_count(self):
        return self.eventregistrations.count()


class EventRegistrationManager(models.Manager):
    def registrations_last_week(self):
        last_week = datetime.datetime.now() - datetime.timedelta(days=7)
        return self.filter(registration_date__gte=last_week).count()

    def registration_details(self):
        return self.values('event__name','event__id').annotate(count=Count('id')).order_by('-count')


class EventRegistration(models.Model):
    event = models.ForeignKey(Event, on_delete=models.CASCADE, related_name='eventregistrations')
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    registration_date = models.DateTimeField(auto_now_add=True)

    objects = EventRegistrationManager()

    class Meta:
        unique_together = ['event', 'user']

    def __str__(self):
        return f"{self.user.username} - {self.event.name}"

class EventImage(models.Model):
    event = models.OneToOneField(Event, on_delete=models.CASCADE)
    image = models.ImageField(upload_to='event_image/')


class EventAgenda(models.Model):
    event = models.ForeignKey(Event, on_delete=models.CASCADE)
    session_name = models.CharField(max_length=120)
    speaker_name = models.CharField(max_length=120)
    start_time = models.TimeField()
    end_time = models.TimeField()
    venue_name = models.CharField(max_length=255)

class EventMember(models.Model):
    event = models.ForeignKey(Event, on_delete=models.CASCADE)
    user = models.ForeignKey('auth.User', on_delete=models.CASCADE)
    created_user = models.ForeignKey('auth.User', on_delete=models.CASCADE, related_name='eventmember_created_user')
    updated_user = models.ForeignKey('auth.User', on_delete=models.CASCADE, related_name='eventmember_updated_user')
    created_date = models.DateField(auto_now_add=True)
    updated_date = models.DateField(auto_now_add=True)
    status_choice = (
        ('disabled', 'Disabled'),
        ('active', 'Active'),
        ('deleted', 'Deleted'),
        ('blocked', 'Blocked'),
        ('completed', 'Completed'),
    )
    status = models.CharField(choices=status_choice, max_length=10)

    class Meta:
        unique_together = ['event', 'user']

    def __str__(self):
        return str(self.user)

    def get_absolute_url(self):
        return reverse('join-event-list')


class EventUserWishList(models.Model):
    event = models.ForeignKey(Event, on_delete=models.CASCADE)
    user = models.ForeignKey('auth.User', on_delete=models.CASCADE)
    created_user = models.ForeignKey('auth.User', on_delete=models.CASCADE, related_name='eventwishlist_created_user')
    updated_user = models.ForeignKey('auth.User', on_delete=models.CASCADE, related_name='eventwishlist_updated_user')
    created_date = models.DateField(auto_now_add=True)
    updated_date = models.DateField(auto_now_add=True)
    status_choice = (
        ('disabled', 'Disabled'),
        ('active', 'Active'),
        ('deleted', 'Deleted'),
        ('blocked', 'Blocked'),
        ('completed', 'Completed'),
    )
    status = models.CharField(choices=status_choice, max_length=10)

    class Meta:
        unique_together = ['event', 'user']

    def __str__(self):
        return str(self.event)

    def get_absolute_url(self):
        return reverse('event-wish-list')


class UserCoin(models.Model):
    user = models.OneToOneField('auth.User', on_delete=models.CASCADE)
    CHOICE_GAIN_TYPE = (
        ('event', 'Event'),
        ('others', 'Others'),
    )
    gain_type = models.CharField(max_length=6, choices=CHOICE_GAIN_TYPE)
    gain_coin = models.PositiveIntegerField()
    created_user = models.ForeignKey('auth.User', on_delete=models.CASCADE, related_name='usercoin_created_user')
    updated_user = models.ForeignKey('auth.User', on_delete=models.CASCADE, related_name='usercoin_updated_user')
    created_date = models.DateField(auto_now_add=True)
    updated_date = models.DateField(auto_now_add=True)
    status_choice = (
        ('disabled', 'Disabled'),
        ('active', 'Active'),
        ('deleted', 'Deleted'),
        ('blocked', 'Blocked'),
        ('completed', 'Completed'),
    )
    status = models.CharField(choices=status_choice, max_length=10)

    def __str__(self):
        return str(self.user)

    def get_absolute_url(self):
        return reverse('user-mark')