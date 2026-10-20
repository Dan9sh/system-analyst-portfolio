-- Скрипты создания таблиц
CREATE TABLE public."user" (
	user_id varchar(64) NOT NULL,
	phone varchar(32) NULL,
	email varchar(255) NULL,
	timezone varchar(64) NULL,
	is_active bool DEFAULT true NOT NULL,
	created_dt timestamp DEFAULT now() NOT NULL,
	updated_dt timestamp DEFAULT now() NOT NULL,
	CONSTRAINT pk_user PRIMARY KEY (user_id),
	CONSTRAINT uq_user_email UNIQUE (email),
	CONSTRAINT uq_user_phone UNIQUE (phone),
	CONSTRAINT user_created_dt_not_null NOT NULL (created_dt),
	CONSTRAINT user_is_active_not_null NOT NULL (is_active),
	CONSTRAINT user_updated_dt_not_null NOT NULL (updated_dt),
	CONSTRAINT user_user_id_not_null NOT NULL (user_id)
);

CREATE TABLE public.service (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	description text NULL
);

CREATE TABLE public.user_device (
	id serial4 NOT NULL,
	user_id varchar(64) NOT NULL,
	push_token varchar(512) NOT NULL,
	platform varchar(32) NULL,
	is_active bool DEFAULT true NOT NULL,
	updated_dt timestamp DEFAULT now() NOT NULL,
	CONSTRAINT pk_user_device PRIMARY KEY (id),
	CONSTRAINT uq_user_device_token UNIQUE (push_token),
	CONSTRAINT user_device_id_not_null NOT NULL (id),
	CONSTRAINT user_device_is_active_not_null NOT NULL (is_active),
	CONSTRAINT user_device_push_token_not_null NOT NULL (push_token),
	CONSTRAINT user_device_updated_dt_not_null NOT NULL (updated_dt),
	CONSTRAINT user_device_user_id_not_null NOT NULL (user_id),
	CONSTRAINT fk_user_device_user FOREIGN KEY (user_id) REFERENCES public."user"(user_id) ON DELETE CASCADE
);
CREATE INDEX idx_user_device_user_id ON public.user_device (user_id);
