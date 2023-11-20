from django.test import TestCase

# Create your tests here.
from database.models import User, Image, UserTag
from django.db.utils import IntegrityError
from django.core.files.uploadedfile import SimpleUploadedFile
from django.utils import timezone
from freezegun import freeze_time


class ImageModelTest(TestCase):
    @classmethod
    def setUpTestData(cls):
        # Create an in-memory image file for testing
        image_data = b'\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x06\x00\x00\x00zz\xf4\x00\x00\x00\x04gAMA\x00\x00\xb1\x8f\x0b\xfca\x05\x00\x00\x00\x01sRGB\x00\xae\xce\x1c\xe9\x00\x00\x00\tpHYs\x00\x00\x0e\xc3\x00\x00\x0e\xc3\x01\xc7o\xa8d\x00\x00\x00\x19tEXtSoftware\x00www.inkscape.org\x9d\xee}\x07\xf8\x00\x00\x02\x07IDAT\x08\xd7c\xf8\xff\xff?\x00\x05\xfe\x02\xfe\t\xf8\xff\x00\x00\x00\x00IEND\xaeB`\x82'

        cls.image = Image.objects.create(
            data=SimpleUploadedFile(
                "test_image.png", image_data, content_type="image/png")
        )

    def test_image_creation(self):
        # Retrieve the saved image file path
        saved_image_path = self.image.data.path

        # Assert that the file was saved correctly
        self.assertTrue(self.image.id)
        self.assertTrue(saved_image_path.endswith("test_image.png"))

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
        user_instance = User.objects.create(account='another_test_account')

        self.assertIsNone(user_instance.photo)

        user_instance.photo = self.image
        user_instance.save()
        retrieved_image = user_instance.photo
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
