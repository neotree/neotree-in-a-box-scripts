-- public.nt_aliases definition

-- Drop table

-- DROP TABLE public.nt_aliases;

CREATE TABLE public.nt_aliases (
	id serial4 NOT NULL,
	"uuid" uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	"name" text NOT NULL,
	alias text NOT NULL,
	script text NOT NULL,
	old_script text NULL,
	publish_date timestamp DEFAULT now() NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	CONSTRAINT nt_aliases_name_script_unique UNIQUE (name, script),
	CONSTRAINT nt_aliases_pkey PRIMARY KEY (id),
	CONSTRAINT nt_aliases_uuid_unique UNIQUE (uuid)
);


-- public.nt_api_keys definition

-- Drop table

-- DROP TABLE public.nt_api_keys;

CREATE TABLE public.nt_api_keys (
	id serial4 NOT NULL,
	api_key_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	api_key text NOT NULL,
	valid_until timestamp NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT nt_api_keys_api_key_id_unique UNIQUE (api_key_id),
	CONSTRAINT nt_api_keys_api_key_unique UNIQUE (api_key),
	CONSTRAINT nt_api_keys_pkey PRIMARY KEY (id)
);


-- public.nt_config_keys definition

-- Drop table

-- DROP TABLE public.nt_config_keys;

CREATE TABLE public.nt_config_keys (
	id serial4 NOT NULL,
	config_key_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	old_config_key_id text NULL,
	"position" int4 NOT NULL,
	"version" int4 NOT NULL,
	"key" text NOT NULL,
	"label" text NOT NULL,
	summary text NOT NULL,
	"source" text DEFAULT 'editor'::text NULL,
	publish_date timestamp DEFAULT now() NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	preferences jsonb DEFAULT '{"fontSize": {}, "fontStyle": {}, "highlight": {}, "textColor": {}, "fontWeight": {}, "backgroundColor": {}}'::jsonb NOT NULL,
	CONSTRAINT nt_config_keys_config_key_id_unique UNIQUE (config_key_id),
	CONSTRAINT nt_config_keys_key_unique UNIQUE (key),
	CONSTRAINT nt_config_keys_label_unique UNIQUE (label),
	CONSTRAINT nt_config_keys_old_config_key_id_unique UNIQUE (old_config_key_id),
	CONSTRAINT nt_config_keys_pkey PRIMARY KEY (id)
);
CREATE INDEX config_keys_search_index ON public.nt_config_keys USING gin ((((to_tsvector('english'::regconfig, key) || to_tsvector('english'::regconfig, label)) || to_tsvector('english'::regconfig, summary))));


-- public.nt_data_keys definition

-- Drop table

-- DROP TABLE public.nt_data_keys;

CREATE TABLE public.nt_data_keys (
	id serial4 NOT NULL,
	"uuid" uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	unique_key uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	"name" text NOT NULL,
	"label" text DEFAULT ''::text NOT NULL,
	ref_id text NULL,
	data_type text NULL,
	"options" jsonb DEFAULT '[]'::jsonb NOT NULL,
	metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
	"version" int4 NOT NULL,
	publish_date timestamp DEFAULT now() NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	CONSTRAINT nt_data_keys_pkey PRIMARY KEY (id),
	CONSTRAINT nt_data_keys_unique_key_unique UNIQUE (unique_key),
	CONSTRAINT nt_data_keys_uuid_unique UNIQUE (uuid)
);


-- public.nt_devices definition

-- Drop table

-- DROP TABLE public.nt_devices;

CREATE TABLE public.nt_devices (
	id serial4 NOT NULL,
	device_id text NOT NULL,
	device_hash text NOT NULL,
	details jsonb DEFAULT '{}'::jsonb NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	CONSTRAINT nt_devices_device_hash_unique UNIQUE (device_hash),
	CONSTRAINT nt_devices_device_id_unique UNIQUE (device_id),
	CONSTRAINT nt_devices_pkey PRIMARY KEY (id)
);


-- public.nt_drugs_library definition

-- Drop table

-- DROP TABLE public.nt_drugs_library;

CREATE TABLE public.nt_drugs_library (
	id serial4 NOT NULL,
	item_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	"key" text NOT NULL,
	drug text DEFAULT ''::text NOT NULL,
	min_gestation float8 NULL,
	max_gestation float8 NULL,
	min_weight float8 NULL,
	max_weight float8 NULL,
	min_age float8 NULL,
	max_age float8 NULL,
	dosage float8 NULL,
	dosage_multiplier float8 NULL,
	day_of_life text DEFAULT ''::text NOT NULL,
	dosage_text text DEFAULT ''::text NOT NULL,
	management_text text DEFAULT ''::text NOT NULL,
	gestation_key text DEFAULT ''::text NOT NULL,
	weight_key text DEFAULT ''::text NOT NULL,
	diagnosis_key text DEFAULT ''::text NOT NULL,
	age_key text DEFAULT ''::text NOT NULL,
	administration_frequency text DEFAULT ''::text NOT NULL,
	drug_unit text DEFAULT ''::text NOT NULL,
	route_of_administration text DEFAULT ''::text NOT NULL,
	"position" int4 NOT NULL,
	"condition" text DEFAULT ''::text NOT NULL,
	"version" int4 NOT NULL,
	publish_date timestamp DEFAULT now() NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	"type" public."drug_type" DEFAULT 'drug'::drug_type NOT NULL,
	hourly_feed float8 NULL,
	hourly_feed_divider float8 NULL,
	validation_type public."dff_item_validation_type" DEFAULT 'default'::dff_item_validation_type NULL,
	key_id text DEFAULT ''::text NOT NULL,
	gestation_key_id text DEFAULT ''::text NOT NULL,
	weight_key_id text DEFAULT ''::text NOT NULL,
	age_key_id text DEFAULT ''::text NOT NULL,
	diagnosis_key_id text DEFAULT ''::text NOT NULL,
	calculator_condition text DEFAULT ''::text NOT NULL,
	CONSTRAINT nt_drugs_library_item_id_unique UNIQUE (item_id),
	CONSTRAINT nt_drugs_library_key_unique UNIQUE (key),
	CONSTRAINT nt_drugs_library_pkey PRIMARY KEY (id)
);


-- public.nt_editor_info definition

-- Drop table

-- DROP TABLE public.nt_editor_info;

CREATE TABLE public.nt_editor_info (
	id serial4 NOT NULL,
	data_version int4 DEFAULT 1 NOT NULL,
	last_publish_date timestamp NULL,
	last_data_keys_sync_date timestamp NULL,
	CONSTRAINT nt_editor_info_pkey PRIMARY KEY (id)
);


-- public.nt_email_templates definition

-- Drop table

-- DROP TABLE public.nt_email_templates;

CREATE TABLE public.nt_email_templates (
	id serial4 NOT NULL,
	template_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	"name" text NOT NULL,
	"data" jsonb NOT NULL,
	CONSTRAINT nt_email_templates_name_unique UNIQUE (name),
	CONSTRAINT nt_email_templates_pkey PRIMARY KEY (id),
	CONSTRAINT nt_email_templates_template_id_unique UNIQUE (template_id)
);


-- public.nt_hospitals definition

-- Drop table

-- DROP TABLE public.nt_hospitals;

CREATE TABLE public.nt_hospitals (
	id serial4 NOT NULL,
	hospital_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	old_hospital_id text NULL,
	"name" text NOT NULL,
	country text DEFAULT ''::text NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	"version" int4 DEFAULT 1 NOT NULL,
	CONSTRAINT nt_hospitals_hospital_id_unique UNIQUE (hospital_id),
	CONSTRAINT nt_hospitals_name_unique UNIQUE (name),
	CONSTRAINT nt_hospitals_old_hospital_id_unique UNIQUE (old_hospital_id),
	CONSTRAINT nt_hospitals_pkey PRIMARY KEY (id)
);
CREATE INDEX hospitals_search_index ON public.nt_hospitals USING gin (to_tsvector('english'::regconfig, name));


-- public.nt_languages definition

-- Drop table

-- DROP TABLE public.nt_languages;

CREATE TABLE public.nt_languages (
	id serial4 NOT NULL,
	"name" text NOT NULL,
	iso text NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	CONSTRAINT nt_languages_iso_unique UNIQUE (iso),
	CONSTRAINT nt_languages_name_unique UNIQUE (name),
	CONSTRAINT nt_languages_pkey PRIMARY KEY (id)
);


-- public.nt_mailer_settings definition

-- Drop table

-- DROP TABLE public.nt_mailer_settings;

CREATE TABLE public.nt_mailer_settings (
	id serial4 NOT NULL,
	setting_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	"name" text NOT NULL,
	service public."mailer_service" NOT NULL,
	auth_username text NOT NULL,
	auth_password text NOT NULL,
	auth_type text NULL,
	auth_method text NULL,
	host text DEFAULT ''::text NOT NULL,
	port int4 NULL,
	encryption text DEFAULT ''::text NOT NULL,
	from_address text DEFAULT ''::text NOT NULL,
	from_name text DEFAULT ''::text NOT NULL,
	is_active bool DEFAULT false NOT NULL,
	secure bool DEFAULT false NOT NULL,
	CONSTRAINT nt_mailer_settings_name_unique UNIQUE (name),
	CONSTRAINT nt_mailer_settings_pkey PRIMARY KEY (id),
	CONSTRAINT nt_mailer_settings_setting_id_unique UNIQUE (setting_id)
);


-- public.nt_sites definition

-- Drop table

-- DROP TABLE public.nt_sites;

CREATE TABLE public.nt_sites (
	id serial4 NOT NULL,
	site_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	"name" text NOT NULL,
	link text NOT NULL,
	api_key text NOT NULL,
	"type" public."site_type" NOT NULL,
	env public."site_env" DEFAULT 'production'::site_env NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	display_name text NULL,
	country_iso text DEFAULT 'zw'::text NOT NULL,
	country_name text DEFAULT 'Zimbabwe'::text NOT NULL,
	CONSTRAINT nt_sites_display_name_key UNIQUE (display_name),
	CONSTRAINT nt_sites_link_unique UNIQUE (link),
	CONSTRAINT nt_sites_name_unique UNIQUE (name),
	CONSTRAINT nt_sites_pkey PRIMARY KEY (id),
	CONSTRAINT nt_sites_site_id_unique UNIQUE (site_id)
);


-- public.nt_sys definition

-- Drop table

-- DROP TABLE public.nt_sys;

CREATE TABLE public.nt_sys (
	_id serial4 NOT NULL,
	id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	"key" text NOT NULL,
	value text NOT NULL,
	CONSTRAINT nt_sys_id_unique UNIQUE (id),
	CONSTRAINT nt_sys_key_unique UNIQUE (key),
	CONSTRAINT nt_sys_pkey PRIMARY KEY (_id)
);


-- public.nt_tokens definition

-- Drop table

-- DROP TABLE public.nt_tokens;

CREATE TABLE public.nt_tokens (
	id serial4 NOT NULL,
	code int4 NOT NULL,
	secret text NOT NULL,
	valid_until timestamp NOT NULL,
	CONSTRAINT tokens_code_unique UNIQUE (code),
	CONSTRAINT tokens_pkey PRIMARY KEY (id)
);


-- public.nt_user_roles definition

-- Drop table

-- DROP TABLE public.nt_user_roles;

CREATE TABLE public.nt_user_roles (
	id serial4 NOT NULL,
	"name" public."role_name" NOT NULL,
	description text NULL,
	CONSTRAINT nt_user_roles_name_unique UNIQUE (name),
	CONSTRAINT nt_user_roles_pkey PRIMARY KEY (id)
);


-- public.nt_config_keys_history definition

-- Drop table

-- DROP TABLE public.nt_config_keys_history;

CREATE TABLE public.nt_config_keys_history (
	id serial4 NOT NULL,
	"version" int4 NOT NULL,
	config_key_id uuid NOT NULL,
	restore_key uuid NULL,
	"data" jsonb DEFAULT '[]'::jsonb NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT nt_config_keys_history_pkey PRIMARY KEY (id),
	CONSTRAINT nt_config_keys_history_config_key_id_nt_config_keys_config_key_ FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE CASCADE
);


-- public.nt_data_keys_history definition

-- Drop table

-- DROP TABLE public.nt_data_keys_history;

CREATE TABLE public.nt_data_keys_history (
	id serial4 NOT NULL,
	"version" int4 NOT NULL,
	data_key_id uuid NOT NULL,
	restore_key uuid NULL,
	"data" jsonb DEFAULT '[]'::jsonb NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT nt_data_keys_history_pkey PRIMARY KEY (id),
	CONSTRAINT nt_data_keys_history_data_key_id_nt_data_keys_uuid_fk FOREIGN KEY (data_key_id) REFERENCES public.nt_data_keys("uuid") ON DELETE CASCADE
);


-- public.nt_drugs_library_history definition

-- Drop table

-- DROP TABLE public.nt_drugs_library_history;

CREATE TABLE public.nt_drugs_library_history (
	id serial4 NOT NULL,
	"version" int4 NOT NULL,
	item_id uuid NOT NULL,
	restore_key uuid NULL,
	"data" jsonb DEFAULT '[]'::jsonb NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT nt_drugs_library_history_pkey PRIMARY KEY (id),
	CONSTRAINT nt_drugs_library_history_item_id_nt_drugs_library_item_id_fk FOREIGN KEY (item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE CASCADE
);


-- public.nt_hospitals_history definition

-- Drop table

-- DROP TABLE public.nt_hospitals_history;

CREATE TABLE public.nt_hospitals_history (
	id serial4 NOT NULL,
	"version" int4 NOT NULL,
	hospital_id uuid NOT NULL,
	restore_key uuid NULL,
	"data" jsonb DEFAULT '[]'::jsonb NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT nt_hospitals_history_pkey PRIMARY KEY (id),
	CONSTRAINT nt_hospitals_history_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE CASCADE
);


-- public.nt_scripts definition

-- Drop table

-- DROP TABLE public.nt_scripts;

CREATE TABLE public.nt_scripts (
	id serial4 NOT NULL,
	script_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	old_script_id text NULL,
	"version" int4 NOT NULL,
	"type" public."script_type" DEFAULT 'admission'::script_type NOT NULL,
	"position" int4 NOT NULL,
	"source" text DEFAULT 'editor'::text NULL,
	title text NOT NULL,
	print_title text NOT NULL,
	description text DEFAULT ''::text NOT NULL,
	hospital_id uuid NULL,
	exportable bool DEFAULT true NOT NULL,
	nuid_search_enabled bool DEFAULT false NOT NULL,
	nuid_search_fields jsonb DEFAULT '[]'::jsonb NOT NULL,
	publish_date timestamp DEFAULT now() NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	preferences jsonb DEFAULT '{"fontSize": {}, "fontStyle": {}, "highlight": {}, "textColor": {}, "fontWeight": {}, "backgroundColor": {}}'::jsonb NOT NULL,
	print_sections jsonb DEFAULT '[]'::jsonb NOT NULL,
	review_configurations jsonb DEFAULT '[]'::jsonb NOT NULL,
	reviewable bool NULL,
	print_config jsonb DEFAULT '{"sections": [], "footerFields": [], "headerFields": []}'::jsonb NOT NULL,
	CONSTRAINT nt_scripts_old_script_id_unique UNIQUE (old_script_id),
	CONSTRAINT nt_scripts_pkey PRIMARY KEY (id),
	CONSTRAINT nt_scripts_script_id_unique UNIQUE (script_id),
	CONSTRAINT nt_scripts_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE SET NULL
);
CREATE INDEX scripts_search_index ON public.nt_scripts USING gin (((to_tsvector('english'::regconfig, title) || to_tsvector('english'::regconfig, description))));


-- public.nt_scripts_history definition

-- Drop table

-- DROP TABLE public.nt_scripts_history;

CREATE TABLE public.nt_scripts_history (
	id serial4 NOT NULL,
	"version" int4 NOT NULL,
	script_id uuid NOT NULL,
	restore_key uuid NULL,
	"data" jsonb DEFAULT '[]'::jsonb NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT nt_scripts_history_pkey PRIMARY KEY (id),
	CONSTRAINT nt_scripts_history_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE
);


-- public.nt_users definition

-- Drop table

-- DROP TABLE public.nt_users;

CREATE TABLE public.nt_users (
	id serial4 NOT NULL,
	user_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	"role" public."role_name" DEFAULT 'user'::role_name NOT NULL,
	email text NOT NULL,
	"password" text NOT NULL,
	display_name text NOT NULL,
	first_name text NULL,
	last_name text NULL,
	avatar text NULL,
	avatar_sm text NULL,
	avatar_md text NULL,
	activation_date timestamp NULL,
	last_login_date timestamp NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	CONSTRAINT nt_users_email_unique UNIQUE (email),
	CONSTRAINT nt_users_pkey PRIMARY KEY (id),
	CONSTRAINT nt_users_user_id_unique UNIQUE (user_id),
	CONSTRAINT nt_users_role_nt_user_roles_name_fk FOREIGN KEY ("role") REFERENCES public.nt_user_roles("name") ON DELETE CASCADE
);
CREATE INDEX users_search_index ON public.nt_users USING gin (((((to_tsvector('english'::regconfig, email) || to_tsvector('english'::regconfig, display_name)) || to_tsvector('english'::regconfig, first_name)) || to_tsvector('english'::regconfig, last_name))));


-- public.nt_auth_clients definition

-- Drop table

-- DROP TABLE public.nt_auth_clients;

CREATE TABLE public.nt_auth_clients (
	id serial4 NOT NULL,
	client_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	client_token text NOT NULL,
	user_id uuid NULL,
	valid_until timestamp NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT nt_auth_clients_client_id_unique UNIQUE (client_id),
	CONSTRAINT nt_auth_clients_client_token_unique UNIQUE (client_token),
	CONSTRAINT nt_auth_clients_pkey PRIMARY KEY (id),
	CONSTRAINT nt_auth_clients_user_id_nt_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.nt_users(user_id) ON DELETE CASCADE
);


-- public.nt_config_keys_drafts definition

-- Drop table

-- DROP TABLE public.nt_config_keys_drafts;

CREATE TABLE public.nt_config_keys_drafts (
	id serial4 NOT NULL,
	config_key_draft_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	config_key_id uuid NULL,
	"position" int4 NOT NULL,
	"data" jsonb NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	created_by_user_id uuid NULL,
	CONSTRAINT nt_config_keys_drafts_config_key_draft_id_unique UNIQUE (config_key_draft_id),
	CONSTRAINT nt_config_keys_drafts_pkey PRIMARY KEY (id),
	CONSTRAINT nt_config_keys_drafts_config_key_id_nt_config_keys_config_key_i FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE CASCADE,
	CONSTRAINT nt_config_keys_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL
);


-- public.nt_data_keys_drafts definition

-- Drop table

-- DROP TABLE public.nt_data_keys_drafts;

CREATE TABLE public.nt_data_keys_drafts (
	id serial4 NOT NULL,
	"uuid" uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	"name" text NOT NULL,
	unique_key uuid NOT NULL,
	data_key_id uuid NULL,
	"data" jsonb NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	created_by_user_id uuid NULL,
	CONSTRAINT nt_data_keys_drafts_pkey PRIMARY KEY (id),
	CONSTRAINT nt_data_keys_drafts_uuid_unique UNIQUE (uuid),
	CONSTRAINT nt_data_keys_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL,
	CONSTRAINT nt_data_keys_drafts_data_key_id_nt_data_keys_uuid_fk FOREIGN KEY (data_key_id) REFERENCES public.nt_data_keys("uuid") ON DELETE CASCADE
);


-- public.nt_diagnoses definition

-- Drop table

-- DROP TABLE public.nt_diagnoses;

CREATE TABLE public.nt_diagnoses (
	id serial4 NOT NULL,
	diagnosis_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	old_diagnosis_id text NULL,
	old_script_id text NULL,
	"version" int4 NOT NULL,
	script_id uuid NOT NULL,
	"position" int4 NOT NULL,
	"source" text DEFAULT 'editor'::text NULL,
	"expression" text NOT NULL,
	"name" text DEFAULT ''::text NOT NULL,
	description text DEFAULT ''::text NOT NULL,
	"key" text DEFAULT ''::text NULL,
	severity_order int4 NULL,
	expression_meaning text DEFAULT ''::text NOT NULL,
	symptoms jsonb DEFAULT '[]'::jsonb NOT NULL,
	text1 text DEFAULT ''::text NOT NULL,
	text2 text DEFAULT ''::text NOT NULL,
	text3 text DEFAULT ''::text NOT NULL,
	image1 jsonb NULL,
	image2 jsonb NULL,
	image3 jsonb NULL,
	publish_date timestamp DEFAULT now() NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	preferences jsonb DEFAULT '{"fontSize": {}, "fontStyle": {}, "highlight": {}, "textColor": {}, "fontWeight": {}, "backgroundColor": {}}'::jsonb NOT NULL,
	key_id text DEFAULT ''::text NOT NULL,
	CONSTRAINT nt_diagnoses_diagnosis_id_unique UNIQUE (diagnosis_id),
	CONSTRAINT nt_diagnoses_old_diagnosis_id_unique UNIQUE (old_diagnosis_id),
	CONSTRAINT nt_diagnoses_pkey PRIMARY KEY (id),
	CONSTRAINT nt_diagnoses_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE
);
CREATE INDEX diagnoses_search_index ON public.nt_diagnoses USING gin (to_tsvector('english'::regconfig, name));


-- public.nt_diagnoses_history definition

-- Drop table

-- DROP TABLE public.nt_diagnoses_history;

CREATE TABLE public.nt_diagnoses_history (
	id serial4 NOT NULL,
	"version" int4 NOT NULL,
	diagnosis_id uuid NOT NULL,
	script_id uuid NOT NULL,
	restore_key text NULL,
	"data" jsonb DEFAULT '[]'::jsonb NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT nt_diagnoses_history_pkey PRIMARY KEY (id),
	CONSTRAINT nt_diagnoses_history_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE CASCADE,
	CONSTRAINT nt_diagnoses_history_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE
);


-- public.nt_drugs_library_drafts definition

-- Drop table

-- DROP TABLE public.nt_drugs_library_drafts;

CREATE TABLE public.nt_drugs_library_drafts (
	id serial4 NOT NULL,
	item_draft_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	item_id uuid NULL,
	"key" text NOT NULL,
	"position" int4 NOT NULL,
	"data" jsonb NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	"type" public."drug_type" DEFAULT 'drug'::drug_type NOT NULL,
	created_by_user_id uuid NULL,
	CONSTRAINT nt_drugs_library_drafts_item_draft_id_unique UNIQUE (item_draft_id),
	CONSTRAINT nt_drugs_library_drafts_pkey PRIMARY KEY (id),
	CONSTRAINT nt_drugs_library_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL,
	CONSTRAINT nt_drugs_library_drafts_item_id_nt_drugs_library_item_id_fk FOREIGN KEY (item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE CASCADE
);


-- public.nt_files definition

-- Drop table

-- DROP TABLE public.nt_files;

CREATE TABLE public.nt_files (
	id serial4 NOT NULL,
	file_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	owner_id uuid NULL,
	filename text NOT NULL,
	content_type text NOT NULL,
	"size" int4 NOT NULL,
	metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
	"data" bytea NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	CONSTRAINT nt_files_file_id_unique UNIQUE (file_id),
	CONSTRAINT nt_files_pkey PRIMARY KEY (id),
	CONSTRAINT nt_files_owner_id_nt_users_user_id_fk FOREIGN KEY (owner_id) REFERENCES public.nt_users(user_id) ON DELETE CASCADE
);


-- public.nt_files_chunks definition

-- Drop table

-- DROP TABLE public.nt_files_chunks;

CREATE TABLE public.nt_files_chunks (
	id serial4 NOT NULL,
	chunk_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	file_id uuid NOT NULL,
	"data" bytea NOT NULL,
	CONSTRAINT nt_files_chunks_chunk_id_unique UNIQUE (chunk_id),
	CONSTRAINT nt_files_chunks_pkey PRIMARY KEY (id),
	CONSTRAINT nt_files_chunks_file_id_nt_files_file_id_fk FOREIGN KEY (file_id) REFERENCES public.nt_files(file_id) ON DELETE CASCADE
);


-- public.nt_hospitals_drafts definition

-- Drop table

-- DROP TABLE public.nt_hospitals_drafts;

CREATE TABLE public.nt_hospitals_drafts (
	id serial4 NOT NULL,
	hospital_draft_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
	hospital_id uuid NULL,
	"data" jsonb NOT NULL,
	created_by_user_id uuid NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT nt_hospitals_drafts_hospital_draft_id_unique UNIQUE (hospital_draft_id),
	CONSTRAINT nt_hospitals_drafts_pkey PRIMARY KEY (id),
	CONSTRAINT nt_hospitals_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL,
	CONSTRAINT nt_hospitals_drafts_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE CASCADE
);


-- public.nt_screens definition

-- Drop table

-- DROP TABLE public.nt_screens;

CREATE TABLE public.nt_screens (
	id serial4 NOT NULL,
	screen_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	old_screen_id text NULL,
	old_script_id text NULL,
	"version" int4 NOT NULL,
	script_id uuid NOT NULL,
	"type" public."screen_type" NOT NULL,
	"position" int4 NOT NULL,
	"source" text DEFAULT 'editor'::text NULL,
	section_title text NOT NULL,
	preview_title text DEFAULT ''::text NOT NULL,
	preview_print_title text DEFAULT ''::text NOT NULL,
	"condition" text DEFAULT ''::text NOT NULL,
	epic_id text DEFAULT ''::text NOT NULL,
	story_id text DEFAULT ''::text NOT NULL,
	ref_id text DEFAULT ''::text NOT NULL,
	ref_key text DEFAULT ''::text NOT NULL,
	step text DEFAULT ''::text NOT NULL,
	action_text text DEFAULT ''::text NOT NULL,
	content_text text DEFAULT ''::text NOT NULL,
	info_text text DEFAULT ''::text NOT NULL,
	title text NOT NULL,
	title1 text DEFAULT ''::text NOT NULL,
	title2 text DEFAULT ''::text NOT NULL,
	title3 text DEFAULT ''::text NOT NULL,
	title4 text DEFAULT ''::text NOT NULL,
	text1 text DEFAULT ''::text NOT NULL,
	text2 text DEFAULT ''::text NOT NULL,
	text3 text DEFAULT ''::text NOT NULL,
	image1 jsonb NULL,
	image2 jsonb NULL,
	image3 jsonb NULL,
	instructions text DEFAULT ''::text NOT NULL,
	instructions2 text DEFAULT ''::text NOT NULL,
	instructions3 text DEFAULT ''::text NOT NULL,
	instructions4 text DEFAULT ''::text NOT NULL,
	hcw_diagnoses_instructions text DEFAULT ''::text NOT NULL,
	suggested_diagnoses_instructions text DEFAULT ''::text NOT NULL,
	notes text DEFAULT ''::text NOT NULL,
	data_type text DEFAULT ''::text NOT NULL,
	"key" text DEFAULT ''::text NOT NULL,
	"label" text DEFAULT ''::text NOT NULL,
	negative_label text DEFAULT ''::text NOT NULL,
	positive_label text DEFAULT ''::text NOT NULL,
	timer_value int4 NULL,
	multiplier int4 NULL,
	min_value int4 NULL,
	max_value int4 NULL,
	exportable bool DEFAULT true NOT NULL,
	printable bool NULL,
	skippable bool DEFAULT false NOT NULL,
	confidential bool DEFAULT false NOT NULL,
	pre_populate jsonb DEFAULT '[]'::jsonb NOT NULL,
	fields jsonb DEFAULT '[]'::jsonb NOT NULL,
	items jsonb DEFAULT '[]'::jsonb NOT NULL,
	publish_date timestamp DEFAULT now() NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	preferences jsonb DEFAULT '{"fontSize": {}, "fontStyle": {}, "highlight": {}, "textColor": {}, "fontWeight": {}, "backgroundColor": {}}'::jsonb NOT NULL,
	skip_to_condition text DEFAULT ''::text NOT NULL,
	skip_to_screen_id text NULL,
	drugs jsonb DEFAULT '[]'::jsonb NOT NULL,
	fluids jsonb DEFAULT '[]'::jsonb NOT NULL,
	feeds jsonb DEFAULT '[]'::jsonb NOT NULL,
	reasons jsonb DEFAULT '[]'::jsonb NOT NULL,
	"repeatable" bool NULL,
	collection_label text DEFAULT ''::text NOT NULL,
	collection_name text DEFAULT ''::text NOT NULL,
	content_text_image jsonb NULL,
	"list_style" public."list_style" DEFAULT 'none'::list_style NOT NULL,
	key_id text DEFAULT ''::text NOT NULL,
	ref_id_data_key text DEFAULT ''::text NOT NULL,
	ref_key_data_key text DEFAULT ''::text NOT NULL,
	print_display_columns int4 DEFAULT 2 NOT NULL,
	rank_items bool DEFAULT false NOT NULL,
	CONSTRAINT nt_screens_old_screen_id_unique UNIQUE (old_screen_id),
	CONSTRAINT nt_screens_pkey PRIMARY KEY (id),
	CONSTRAINT nt_screens_screen_id_unique UNIQUE (screen_id),
	CONSTRAINT nt_screens_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE
);
CREATE INDEX screens_search_index ON public.nt_screens USING gin (to_tsvector('english'::regconfig, title));


-- public.nt_screens_history definition

-- Drop table

-- DROP TABLE public.nt_screens_history;

CREATE TABLE public.nt_screens_history (
	id serial4 NOT NULL,
	"version" int4 NOT NULL,
	screen_id uuid NOT NULL,
	script_id uuid NOT NULL,
	restore_key text NULL,
	"data" jsonb DEFAULT '[]'::jsonb NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	CONSTRAINT nt_screens_history_pkey PRIMARY KEY (id),
	CONSTRAINT nt_screens_history_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE CASCADE,
	CONSTRAINT nt_screens_history_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE
);


-- public.nt_scripts_drafts definition

-- Drop table

-- DROP TABLE public.nt_scripts_drafts;

CREATE TABLE public.nt_scripts_drafts (
	id serial4 NOT NULL,
	script_draft_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	script_id uuid NULL,
	"position" int4 NOT NULL,
	"data" jsonb NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	hospital_id uuid NULL,
	created_by_user_id uuid NULL,
	CONSTRAINT nt_scripts_drafts_pkey PRIMARY KEY (id),
	CONSTRAINT nt_scripts_drafts_script_draft_id_unique UNIQUE (script_draft_id),
	CONSTRAINT nt_scripts_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL,
	CONSTRAINT nt_scripts_drafts_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE SET NULL,
	CONSTRAINT nt_scripts_drafts_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE
);


-- public.nt_change_logs definition

-- Drop table

-- DROP TABLE public.nt_change_logs;

CREATE TABLE public.nt_change_logs (
	id serial4 NOT NULL,
	change_log_id uuid DEFAULT public.gen_random_uuid() NOT NULL,
	"version" int4 NOT NULL,
	entity_type public."change_log_entity" NOT NULL,
	entity_id uuid NOT NULL,
	parent_version int4 NULL,
	merged_from_version int4 NULL,
	script_id uuid NULL,
	screen_id uuid NULL,
	diagnosis_id uuid NULL,
	config_key_id uuid NULL,
	drugs_library_item_id uuid NULL,
	data_key_id uuid NULL,
	alias_id uuid NULL,
	"action" public."change_log_action" NOT NULL,
	changes jsonb DEFAULT '[]'::jsonb NOT NULL,
	full_snapshot jsonb NOT NULL,
	description text DEFAULT ''::text NOT NULL,
	change_reason text DEFAULT ''::text NOT NULL,
	is_active bool DEFAULT true NOT NULL,
	superseded_by int4 NULL,
	superseded_at timestamp NULL,
	user_id uuid NOT NULL,
	date_of_change timestamp DEFAULT now() NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	data_version int4 NULL,
	hospital_id uuid NULL,
	snapshot_hash text NULL,
	previous_snapshot jsonb DEFAULT '{}'::jsonb NOT NULL,
	CONSTRAINT nt_change_logs_change_log_id_unique UNIQUE (change_log_id),
	CONSTRAINT nt_change_logs_pkey PRIMARY KEY (id),
	CONSTRAINT nt_change_logs_alias_id_nt_aliases_uuid_fk FOREIGN KEY (alias_id) REFERENCES public.nt_aliases("uuid") ON DELETE SET NULL,
	CONSTRAINT nt_change_logs_config_key_id_nt_config_keys_config_key_id_fk FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE SET NULL,
	CONSTRAINT nt_change_logs_data_key_id_nt_data_keys_uuid_fk FOREIGN KEY (data_key_id) REFERENCES public.nt_data_keys("uuid") ON DELETE SET NULL,
	CONSTRAINT nt_change_logs_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE SET NULL,
	CONSTRAINT nt_change_logs_drugs_library_item_id_nt_drugs_library_item_id_f FOREIGN KEY (drugs_library_item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE SET NULL,
	CONSTRAINT nt_change_logs_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE SET NULL,
	CONSTRAINT nt_change_logs_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE SET NULL,
	CONSTRAINT nt_change_logs_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE SET NULL,
	CONSTRAINT nt_change_logs_user_id_nt_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL
);
CREATE INDEX active_version_index ON public.nt_change_logs USING btree (entity_id, is_active);
CREATE INDEX change_logs_data_version_index ON public.nt_change_logs USING btree (data_version);
CREATE INDEX change_logs_date_index ON public.nt_change_logs USING btree (date_of_change);
CREATE INDEX change_logs_entity_index ON public.nt_change_logs USING btree (entity_type, entity_id);
CREATE INDEX change_logs_user_index ON public.nt_change_logs USING btree (user_id);
CREATE UNIQUE INDEX unique_version_per_entity ON public.nt_change_logs USING btree (entity_type, entity_id, version);
CREATE INDEX version_chain_index ON public.nt_change_logs USING btree (entity_id, parent_version);


-- public.nt_diagnoses_drafts definition

-- Drop table

-- DROP TABLE public.nt_diagnoses_drafts;

CREATE TABLE public.nt_diagnoses_drafts (
	id serial4 NOT NULL,
	diagnosis_draft_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	diagnosis_id uuid NULL,
	script_id uuid NULL,
	script_draft_id uuid NULL,
	"position" int4 NOT NULL,
	"data" jsonb NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	created_by_user_id uuid NULL,
	CONSTRAINT nt_diagnoses_drafts_diagnosis_draft_id_unique UNIQUE (diagnosis_draft_id),
	CONSTRAINT nt_diagnoses_drafts_pkey PRIMARY KEY (id),
	CONSTRAINT nt_diagnoses_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL,
	CONSTRAINT nt_diagnoses_drafts_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE CASCADE,
	CONSTRAINT nt_diagnoses_drafts_script_draft_id_nt_scripts_drafts_script_dr FOREIGN KEY (script_draft_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE,
	CONSTRAINT nt_diagnoses_drafts_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE
);


-- public.nt_lock definition

-- Drop table

-- DROP TABLE public.nt_lock;

CREATE TABLE public.nt_lock (
	lock_id uuid DEFAULT uuid_generate_v4() NOT NULL,
	user_id uuid NOT NULL,
	locked_at timestamp NOT NULL,
	script_id uuid NULL,
	lock_type varchar(20) DEFAULT 'script'::character varying NOT NULL,
	new_script_id uuid NULL,
	CONSTRAINT nt_lock_lock_type_check CHECK (((lock_type)::text = ANY (ARRAY[('script'::character varying)::text, ('data_key'::character varying)::text, ('drug_library'::character varying)::text]))),
	CONSTRAINT nt_lock_pkey PRIMARY KEY (lock_id),
	CONSTRAINT fk_new_script_id FOREIGN KEY (new_script_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE,
	CONSTRAINT fk_script_id FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE,
	CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.nt_users(user_id) ON DELETE CASCADE
);


-- public.nt_screens_drafts definition

-- Drop table

-- DROP TABLE public.nt_screens_drafts;

CREATE TABLE public.nt_screens_drafts (
	id serial4 NOT NULL,
	screen_draft_id uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL,
	screen_id uuid NULL,
	script_id uuid NULL,
	script_draft_id uuid NULL,
	"type" public."screen_type" NOT NULL,
	"position" int4 NOT NULL,
	"data" jsonb NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	created_by_user_id uuid NULL,
	CONSTRAINT nt_screens_drafts_pkey PRIMARY KEY (id),
	CONSTRAINT nt_screens_drafts_screen_draft_id_unique UNIQUE (screen_draft_id),
	CONSTRAINT nt_screens_drafts_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL,
	CONSTRAINT nt_screens_drafts_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE CASCADE,
	CONSTRAINT nt_screens_drafts_script_draft_id_nt_scripts_drafts_script_draf FOREIGN KEY (script_draft_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE,
	CONSTRAINT nt_screens_drafts_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE
);


-- public.nt_pending_deletion definition

-- Drop table

-- DROP TABLE public.nt_pending_deletion;

CREATE TABLE public.nt_pending_deletion (
	id serial4 NOT NULL,
	script_id uuid NULL,
	screen_id uuid NULL,
	screen_script_id uuid NULL,
	diagnosis_id uuid NULL,
	diagnosis_script_id uuid NULL,
	config_key_id uuid NULL,
	script_draft_id uuid NULL,
	screen_draft_id uuid NULL,
	diagnosis_draft_id uuid NULL,
	config_key_draft_id uuid NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	drugs_library_item_id uuid NULL,
	drugs_library_item_draft_id uuid NULL,
	alias_id uuid NULL,
	data_key_id uuid NULL,
	data_key_draft_id uuid NULL,
	created_by_user_id uuid NULL,
	hospital_id uuid NULL,
	hospital_draft_id uuid NULL,
	CONSTRAINT nt_pending_deletion_pkey PRIMARY KEY (id),
	CONSTRAINT nt_pending_deletion_config_key_draft_id_nt_config_keys_drafts_c FOREIGN KEY (config_key_draft_id) REFERENCES public.nt_config_keys_drafts(config_key_draft_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_config_key_id_nt_config_keys_config_key_id_ FOREIGN KEY (config_key_id) REFERENCES public.nt_config_keys(config_key_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_created_by_user_id_nt_users_user_id_fk FOREIGN KEY (created_by_user_id) REFERENCES public.nt_users(user_id) ON DELETE SET NULL,
	CONSTRAINT nt_pending_deletion_diagnosis_draft_id_nt_diagnoses_drafts_diag FOREIGN KEY (diagnosis_draft_id) REFERENCES public.nt_diagnoses_drafts(diagnosis_draft_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_diagnosis_id_nt_diagnoses_diagnosis_id_fk FOREIGN KEY (diagnosis_id) REFERENCES public.nt_diagnoses(diagnosis_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_diagnosis_script_id_nt_scripts_script_id_fk FOREIGN KEY (diagnosis_script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_drugs_library_item_draft_id_nt_drugs_librar FOREIGN KEY (drugs_library_item_draft_id) REFERENCES public.nt_drugs_library_drafts(item_draft_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_drugs_library_item_id_nt_drugs_library_item FOREIGN KEY (drugs_library_item_id) REFERENCES public.nt_drugs_library(item_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_hospital_draft_id_nt_hospitals_drafts_hospi FOREIGN KEY (hospital_draft_id) REFERENCES public.nt_hospitals_drafts(hospital_draft_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_hospital_id_nt_hospitals_hospital_id_fk FOREIGN KEY (hospital_id) REFERENCES public.nt_hospitals(hospital_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_screen_draft_id_nt_screens_drafts_screen_dr FOREIGN KEY (screen_draft_id) REFERENCES public.nt_screens_drafts(screen_draft_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_screen_id_nt_screens_screen_id_fk FOREIGN KEY (screen_id) REFERENCES public.nt_screens(screen_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_screen_script_id_nt_scripts_script_id_fk FOREIGN KEY (screen_script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_script_draft_id_nt_scripts_drafts_script_dr FOREIGN KEY (script_draft_id) REFERENCES public.nt_scripts_drafts(script_draft_id) ON DELETE CASCADE,
	CONSTRAINT nt_pending_deletion_script_id_nt_scripts_script_id_fk FOREIGN KEY (script_id) REFERENCES public.nt_scripts(script_id) ON DELETE CASCADE
);
