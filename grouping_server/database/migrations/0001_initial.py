# Generated by Django 4.2.2 on 2023-12-06 16:11

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ("auth", "0012_alter_user_first_name_max_length"),
    ]

    operations = [
        migrations.CreateModel(
            name="User",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "last_login",
                    models.DateTimeField(
                        blank=True, null=True, verbose_name="last login"
                    ),
                ),
                (
                    "account",
                    models.CharField(max_length=20, unique=True, verbose_name="帳號"),
                ),
                ("password", models.CharField(max_length=20, verbose_name="密碼")),
                (
                    "real_name",
                    models.CharField(default="", max_length=20, verbose_name="真實名稱"),
                ),
                (
                    "user_name",
                    models.CharField(default="", max_length=20, verbose_name="用戶名稱"),
                ),
                (
                    "slogan",
                    models.CharField(default="", max_length=20, verbose_name="座右銘"),
                ),
                ("introduction", models.TextField(default="", verbose_name="簡介")),
                ("is_staff", models.BooleanField(default=False)),
                ("is_superuser", models.BooleanField(default=False)),
                (
                    "groups",
                    models.ManyToManyField(
                        blank=True,
                        help_text="The groups this user belongs to. A user will get all permissions granted to each of their groups.",
                        related_name="user_set",
                        related_query_name="user",
                        to="auth.group",
                        verbose_name="groups",
                    ),
                ),
            ],
            options={"abstract": False,},
        ),
        migrations.CreateModel(
            name="Activity",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("title", models.CharField(max_length=20)),
                ("description", models.CharField(max_length=20)),
                ("created_at", models.DateTimeField(auto_now_add=True)),
            ],
        ),
        migrations.CreateModel(
            name="Image",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("data", models.ImageField(upload_to="images/")),
                ("updated_at", models.DateTimeField(auto_now=True)),
            ],
        ),
        migrations.CreateModel(
            name="Workspace",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("theme_color", models.IntegerField()),
                ("workspace_name", models.CharField(max_length=20)),
                ("description", models.TextField()),
                ("is_personal", models.BooleanField()),
                (
                    "members",
                    models.ManyToManyField(
                        related_name="joined_workspaces", to=settings.AUTH_USER_MODEL
                    ),
                ),
                (
                    "photo",
                    models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.SET_NULL,
                        to="database.image",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Event",
            fields=[
                (
                    "belong_activity",
                    models.OneToOneField(
                        on_delete=django.db.models.deletion.CASCADE,
                        primary_key=True,
                        serialize=False,
                        to="database.activity",
                    ),
                ),
                ("start_time", models.DateTimeField()),
                ("end_time", models.DateTimeField()),
            ],
        ),
        migrations.CreateModel(
            name="WorkspaceTag",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("content", models.CharField(max_length=20)),
                (
                    "belong_workspace",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="tags",
                        to="database.workspace",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="UserTag",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("title", models.CharField(max_length=20)),
                ("content", models.CharField(max_length=20)),
                (
                    "belong_user",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="tags",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="MissionState",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "stage",
                    models.CharField(
                        choices=[
                            ("IN_PROGRESS", "in progress"),
                            ("PENDING", "pending"),
                            ("CLOSE", "close"),
                        ],
                        default="IN_PROGRESS",
                        max_length=15,
                    ),
                ),
                ("name", models.CharField(max_length=20)),
                (
                    "belong_workspace",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="database.workspace",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="ActivityNotification",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("notify_time", models.DateTimeField()),
                (
                    "belong_activity",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="notifications",
                        to="database.activity",
                    ),
                ),
            ],
        ),
        migrations.AddField(
            model_name="activity",
            name="belong_workspace",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="activities",
                to="database.workspace",
            ),
        ),
        migrations.AddField(
            model_name="activity",
            name="children",
            field=models.ManyToManyField(
                blank=True, related_name="parents", to="database.activity"
            ),
        ),
        migrations.AddField(
            model_name="activity",
            name="contributors",
            field=models.ManyToManyField(
                related_name="contributing_activities", to=settings.AUTH_USER_MODEL
            ),
        ),
        migrations.AddField(
            model_name="activity",
            name="creator",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL
            ),
        ),
        migrations.AddField(
            model_name="user",
            name="photo",
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.SET_NULL,
                to="database.image",
                verbose_name="頭像",
            ),
        ),
        migrations.AddField(
            model_name="user",
            name="user_permissions",
            field=models.ManyToManyField(
                blank=True,
                help_text="Specific permissions for this user.",
                related_name="user_set",
                related_query_name="user",
                to="auth.permission",
                verbose_name="user permissions",
            ),
        ),
        migrations.CreateModel(
            name="Mission",
            fields=[
                (
                    "belong_activity",
                    models.OneToOneField(
                        on_delete=django.db.models.deletion.CASCADE,
                        primary_key=True,
                        serialize=False,
                        to="database.activity",
                    ),
                ),
                ("deadline", models.DateTimeField()),
                (
                    "state",
                    models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.SET_NULL,
                        to="database.missionstate",
                    ),
                ),
            ],
        ),
    ]
