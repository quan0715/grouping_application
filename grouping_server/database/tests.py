from django.test import TestCase

# Create your tests here.
import os
from django.test import override_settings
from django.conf import settings
from database.models import User, Image, UserTag, Workspace, WorkspaceTag, \
    MissionState, Activity, ActivityNotification
from django.db.utils import IntegrityError
from django.core.files.uploadedfile import SimpleUploadedFile
from django.utils import timezone
from freezegun import freeze_time


@override_settings(MEDIA_ROOT=settings.UNIT_TEST_ROOT)
class ImageModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        # Create an in-memory image file for testing
        image_data = b'\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x06\x00\x00\x00zz\xf4\x00\x00\x00\x04gAMA\x00\x00\xb1\x8f\x0b\xfca\x05\x00\x00\x00\x01sRGB\x00\xae\xce\x1c\xe9\x00\x00\x00\tpHYs\x00\x00\x0e\xc3\x00\x00\x0e\xc3\x01\xc7o\xa8d\x00\x00\x00\x19tEXtSoftware\x00www.inkscape.org\x9d\xee}\x07\xf8\x00\x00\x02\x07IDAT\x08\xd7c\xf8\xff\xff?\x00\x05\xfe\x02\xfe\t\xf8\xff\x00\x00\x00\x00IEND\xaeB`\x82'

        cls.image = Image.objects.create(
            data=SimpleUploadedFile(
                "test_image.png", image_data, content_type="image/png")
        )

    @classmethod
    def tearDownClass(cls):
        # Clean up the temporary media folder
        image_folder = os.path.join(settings.MEDIA_ROOT, "images")
        for file_name in os.listdir(image_folder):
            file_path = os.path.join(image_folder, file_name)
            os.remove(file_path)
        os.rmdir(image_folder)
        os.rmdir(settings.MEDIA_ROOT)
        super().tearDownClass()

    def test_image_creation(self):
        # Retrieve the saved image file path
        saved_image_path: str = self.image.data.path

        # Assert that the file was saved correctly
        self.assertTrue(self.image.id)
        self.assertTrue(saved_image_path.find("test_image") != -1)
        self.assertTrue(saved_image_path.find(".png") != -1)

    def test_updated_at_auto_now(self):
        # Get the initial updated_at timestamp
        initial_updated_at = self.image.updated_at

        # Use freezegun to freeze time to a specific date
        frozen_date = timezone.datetime(2023, 1, 1, tzinfo=timezone.utc)
        with freeze_time(frozen_date):
            # Save the image instance, triggering auto_now
            self.image.save()

        # Get the updated updated_at timestamp
        new_updated_at = self.image.updated_at

        # Assert that the updated_at field has changed and is equal to the frozen date
        self.assertNotEqual(initial_updated_at, new_updated_at)
        self.assertAlmostEqual(new_updated_at, frozen_date,
                               delta=timezone.timedelta(seconds=1))


class UserModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.image = Image.objects.create()
        cls.user = User.objects.create(
            account='unit_test_account', photo=cls.image)

    def test_account_max_length(self):
        max_length = self.user._meta.get_field('account').max_length
        self.assertEquals(max_length, 20)

    def test_account_label(self):
        field_label = self.user._meta.get_field('account').verbose_name
        self.assertEquals(field_label, '帳號')

    def test_account_uniqueness(self):
        with self.assertRaises(IntegrityError):
            User.objects.create(
                account='unit_test_account',
                password='another_test_password',
                real_name='another_test_real_name',
                user_name='another_test_user_name',
                slogan='another_test_slogan',
                introduction='another_test_introduction',
                photo=None
            )

    def test_password_max_length(self):
        max_length = self.user._meta.get_field('password').max_length
        self.assertEquals(max_length, 20)

    def test_password_label(self):
        field_label = self.user._meta.get_field('password').verbose_name
        self.assertEquals(field_label, '密碼')

    def test_real_name_max_length(self):
        max_length = self.user._meta.get_field('real_name').max_length
        self.assertEquals(max_length, 20)

    def test_real_name_label(self):
        field_label = self.user._meta.get_field('real_name').verbose_name
        self.assertEquals(field_label, '真實名稱')

    def test_user_name_max_length(self):
        max_length = self.user._meta.get_field('user_name').max_length
        self.assertEquals(max_length, 20)

    def test_user_name_label(self):
        field_label = self.user._meta.get_field('user_name').verbose_name
        self.assertEquals(field_label, '用戶名稱')

    def test_slogan_max_length(self):
        max_length = self.user._meta.get_field('slogan').max_length
        self.assertEquals(max_length, 20)

    def test_slogan_label(self):
        field_label = self.user._meta.get_field('slogan').verbose_name
        self.assertEquals(field_label, '座右銘')

    def test_introduction_label(self):
        field_label = self.user._meta.get_field('introduction').verbose_name
        self.assertEquals(field_label, '簡介')

    def test_photo_creation(self):
        retrieved_image = self.user.photo
        self.assertEqual(retrieved_image, self.image)

    def test_photo_nullability(self):
        another_user = User.objects.create(account='another_test_account')

        self.assertIsNone(another_user.photo)

        another_user.photo = self.image
        another_user.save()
        retrieved_image = another_user.photo
        self.assertEqual(retrieved_image, self.image)

    def test_photo_label(self):
        field_label = self.user._meta.get_field('photo').verbose_name
        self.assertEquals(field_label, '頭像')

    def test_object_name_is_correct(self):
        expected_object_name = f"id:{self.user.id} user_name:{self.user.user_name}"
        self.assertEqual(expected_object_name, str(self.user))


class UserTagModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.user = User.objects.create()
        cls.tag = UserTag.objects.create(belong_user=cls.user)

    def test_user_tag_creation(self):
        retrieved_user = self.tag.belong_user
        self.assertEqual(retrieved_user, self.user)

    def test_related_name_in_user(self):
        retrieved_tags = self.user.tags.all()
        self.assertIn(self.tag, retrieved_tags)

    def test_user_relative_field_with_delete_tag(self):
        self.tag.delete()
        retrieved_tags = self.user.tags.all()
        self.assertEqual(retrieved_tags.count(), 0)

    def test_title_max_length(self):
        max_length = self.tag._meta.get_field('title').max_length
        self.assertEquals(max_length, 20)

    def test_title_label(self):
        field_label = self.tag._meta.get_field('title').verbose_name
        self.assertEquals(field_label, '標題')

    def test_content_max_length(self):
        max_length = self.tag._meta.get_field('content').max_length
        self.assertEquals(max_length, 20)

    def test_content_label(self):
        field_label = self.tag._meta.get_field('content').verbose_name
        self.assertEquals(field_label, '內容')

    def test_cascade_delete_user(self):
        self.user.delete()
        with self.assertRaises(UserTag.DoesNotExist):
            UserTag.objects.get(id=self.tag.id)


class WorkspaceModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.image = Image.objects.create()
        cls.user = User.objects.create()
        cls.workspace = Workspace.objects.create(
            theme_color=0, is_personal=True, photo=cls.image)

    def test_theme_color_label(self):
        field_label = self.workspace._meta.get_field(
            'theme_color').verbose_name
        self.assertEquals(field_label, '主題顏色')

    def test_workspace_name_max_length(self):
        max_length = self.workspace._meta.get_field(
            'workspace_name').max_length
        self.assertEquals(max_length, 20)

    def test_workspace_name_label(self):
        field_label = self.workspace._meta.get_field(
            'workspace_name').verbose_name
        self.assertEquals(field_label, '名稱')

    def test_description_label(self):
        field_label = self.workspace._meta.get_field(
            'description').verbose_name
        self.assertEquals(field_label, '簡介')

    def test_photo_creation(self):
        retrieved_image = self.workspace.photo
        self.assertEqual(retrieved_image, self.image)

    def test_photo_nullability(self):
        another_workspace = Workspace.objects.create(
            theme_color=0, is_personal=True)

        self.assertIsNone(another_workspace.photo)

        another_workspace.photo = self.image
        another_workspace.save()
        retrieved_image = another_workspace.photo
        self.assertEqual(retrieved_image, self.image)

    def test_photo_label(self):
        field_label = self.workspace._meta.get_field('photo').verbose_name
        self.assertEquals(field_label, '頭像')

    def test_members_relation(self):
        self.workspace.members.add(self.user)
        self.assertIn(self.user,
                      self.workspace.members.all())
        self.assertIn(self.workspace,
                      self.user.joined_workspaces.all())


class WorkspaceTagModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.workspace = Workspace.objects.create(
            theme_color=0, is_personal=True)
        cls.tag = WorkspaceTag.objects.create(belong_workspace=cls.workspace)

    def test_workspace_tag_creation(self):
        retrieved_workspace = self.tag.belong_workspace
        self.assertEqual(retrieved_workspace, self.workspace)

    def test_related_name_in_workspace(self):
        retrieved_tags = self.workspace.tags.all()
        self.assertIn(self.tag, retrieved_tags)

    def test_workspace_relative_field_with_delete_tag(self):
        self.tag.delete()
        retrieved_tags = self.workspace.tags.all()
        self.assertEqual(retrieved_tags.count(), 0)

    def test_content_max_length(self):
        max_length = self.tag._meta.get_field('content').max_length
        self.assertEquals(max_length, 20)

    def test_content_label(self):
        field_label = self.tag._meta.get_field('content').verbose_name
        self.assertEquals(field_label, '內容')

    def test_cascade_delete_workspace(self):
        self.workspace.delete()
        with self.assertRaises(WorkspaceTag.DoesNotExist):
            WorkspaceTag.objects.get(id=self.tag.id)


class MissionStateModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.workspace = Workspace.objects.create(
            theme_color=0, is_personal=True)
        cls.mission_state = MissionState.objects.create(
            stage=MissionState.Stage.IN_PROGRESS,
            name='Test Mission State',
            belong_workspace=cls.workspace,
        )

    def test_mission_state_creation(self):
        self.assertTrue(self.mission_state.id)
        self.assertEqual(self.mission_state.stage,
                         MissionState.Stage.IN_PROGRESS)
        self.assertEqual(self.mission_state.name, 'Test Mission State')
        self.assertEqual(self.mission_state.belong_workspace, self.workspace)

    def test_default_stage(self):
        new_mission_state = MissionState.objects.create(
            name='Another Mission State',
            belong_workspace=self.workspace,
        )

        self.assertEqual(new_mission_state.stage,
                         MissionState.Stage.IN_PROGRESS)

    def test_name_max_length(self):
        max_length = self.mission_state._meta.get_field('name').max_length
        self.assertEquals(max_length, 20)

    def test_name_label(self):
        field_label = self.mission_state._meta.get_field('name').verbose_name
        self.assertEquals(field_label, '名稱')

    def test_cascade_delete_workspace(self):
        self.workspace.delete()
        with self.assertRaises(MissionState.DoesNotExist):
            MissionState.objects.get(id=self.mission_state.id)


class ActivityModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.user = User.objects.create()
        cls.workspace = Workspace.objects.create(
            theme_color=0, is_personal=True)
        cls.contributor = User.objects.create(account="contributor")
        cls.child = Activity.objects.create(
            creator=cls.user, belong_workspace=cls.workspace)
        cls.frozen_date = timezone.datetime(2023, 1, 1, tzinfo=timezone.utc)
        with freeze_time(cls.frozen_date):
            cls.activity = Activity.objects.create(
                creator=cls.user, belong_workspace=cls.workspace)

    def test_title_max_length(self):
        max_length = self.activity._meta.get_field('title').max_length
        self.assertEquals(max_length, 20)

    def test_description_max_length(self):
        max_length = self.activity._meta.get_field('description').max_length
        self.assertEquals(max_length, 20)

    def test_created_at(self):
        created_at = self.activity.created_at
        self.assertAlmostEqual(created_at, self.frozen_date,
                               delta=timezone.timedelta(seconds=1))

    def test_cascade_delete_creator(self):
        self.user.delete()
        with self.assertRaises(Activity.DoesNotExist):
            Activity.objects.get(id=self.activity.id)

    def test_cascade_delete_creator(self):
        self.workspace.delete()
        with self.assertRaises(Activity.DoesNotExist):
            Activity.objects.get(id=self.activity.id)

    def test_children_relation(self):
        self.activity.children.add(self.child)
        self.assertIn(self.child,
                      self.activity.children.all())
        self.assertIn(self.activity,
                      self.child.parents.all())

    def test_children_deletion(self):
        self.child.delete()
        self.assertNotIn(self.child,
                         self.activity.children.all())

    def test_contributors_relation(self):
        self.activity.contributors.add(self.contributor)
        self.assertIn(self.contributor,
                      self.activity.contributors.all())
        self.assertIn(self.activity,
                      self.contributor.contributing_activities.all())

    def test_contributors_deletion(self):
        self.contributor.delete()
        self.assertNotIn(self.contributor,
                         self.activity.contributors.all())


class ActivityNotificationTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        cls.user = User.objects.create()
        cls.workspace = Workspace.objects.create(
            theme_color=0, is_personal=True)
        cls.activity = Activity.objects.create(
            creator=cls.user, belong_workspace=cls.workspace)
        cls.notification = ActivityNotification.objects.create(
            belong_activity=cls.activity, notify_time=timezone.datetime(2023, 1, 1, tzinfo=timezone.utc))

    def test_activity_notification_creation(self):
        retrieved_notification = self.notification.belong_activity
        self.assertEqual(retrieved_notification, self.activity)
        self.assertEqual(timezone.datetime(
            2023, 1, 1, tzinfo=timezone.utc), self.notification.notify_time)

    def test_related_name_in_activity(self):
        retrieved_notifications = self.activity.notifications.all()
        self.assertIn(self.notification, retrieved_notifications)

    def test_activity_relative_field_with_delete_notification(self):
        self.notification.delete()
        retrieved_notifications = self.activity.notifications.all()
        self.assertEqual(retrieved_notifications.count(), 0)

    def test_cascade_delete_activity(self):
        self.activity.delete()
        with self.assertRaises(ActivityNotification.DoesNotExist):
            ActivityNotification.objects.get(id=self.notification.id)
