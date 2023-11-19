from django.test import TestCase

# Create your tests here.
from database.models import User, Image
from django.db.utils import IntegrityError


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
