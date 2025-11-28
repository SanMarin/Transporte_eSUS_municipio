SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Banco de dados: `bpa_transport_system`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `activity_log`
--

CREATE TABLE `activity_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `bpa_headers`
--

CREATE TABLE `bpa_headers` (
  `id` int(11) NOT NULL,
  `cbc_mvm` varchar(6) NOT NULL COMMENT 'Ano e mês de processamento (AAAAMM)',
  `cbc_lin` int(11) DEFAULT 0 COMMENT 'Número de linhas do BPA gravadas',
  `cbc_flh` int(11) DEFAULT 0 COMMENT 'Quantidade de folhas de BPA gravadas',
  `cbc_smt_vrf` varchar(4) DEFAULT '1111' COMMENT 'Campo de controle',
  `status` enum('draft','finalized') DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `bpa_records`
--

CREATE TABLE `bpa_records` (
  `id` int(11) NOT NULL,
  `header_id` int(11) NOT NULL,
  `prd_cnes` varchar(7) NOT NULL COMMENT 'Código do CNES',
  `prd_cmp` varchar(6) NOT NULL COMMENT 'Competência (AAAAMM)',
  `prd_cnsmed` varchar(15) NOT NULL COMMENT 'CNS do profissional',
  `prd_cbo` varchar(6) NOT NULL COMMENT 'CBO do profissional',
  `prd_dtaten` date NOT NULL COMMENT 'Data de atendimento',
  `prd_flh` varchar(3) NOT NULL COMMENT 'Número da folha',
  `prd_seq` varchar(2) NOT NULL COMMENT 'Sequencial na folha',
  `prd_pa` varchar(10) NOT NULL COMMENT 'Código do procedimento',
  `prd_cnspac` varchar(15) NOT NULL COMMENT 'CNS do paciente',
  `prd_sexo` char(1) NOT NULL COMMENT 'Sexo do paciente',
  `prd_ibge` varchar(6) DEFAULT NULL COMMENT 'Código IBGE do município',
  `prd_cid` varchar(4) NOT NULL COMMENT 'CID-10',
  `prd_idade` varchar(3) NOT NULL COMMENT 'Idade do paciente',
  `prd_qt` varchar(6) NOT NULL COMMENT 'Quantidade de procedimentos',
  `prd_caten` varchar(2) DEFAULT '01' COMMENT 'Caracter de atendimento',
  `prd_naut` varchar(13) DEFAULT NULL COMMENT 'Número da autorização',
  `prd_org` varchar(3) DEFAULT 'BPA' COMMENT 'Origem das informações',
  `prd_nmpac` varchar(30) NOT NULL COMMENT 'Nome do paciente',
  `prd_dtnasc` date NOT NULL COMMENT 'Data de nascimento',
  `prd_raca` varchar(2) DEFAULT NULL COMMENT 'Raça/cor',
  `prd_etnia` varchar(4) DEFAULT NULL COMMENT 'Etnia',
  `prd_nac` varchar(3) DEFAULT NULL COMMENT 'Nacionalidade',
  `prd_srv` varchar(3) DEFAULT NULL COMMENT 'Código do serviço',
  `prd_clf` varchar(3) DEFAULT NULL COMMENT 'Código da classificação',
  `prd_equipe_seq` varchar(8) DEFAULT NULL,
  `prd_equipe_area` varchar(4) DEFAULT NULL,
  `prd_cnpj` varchar(14) DEFAULT NULL,
  `prd_cep` varchar(8) DEFAULT NULL,
  `prd_lograd` varchar(3) DEFAULT NULL,
  `prd_end` varchar(30) DEFAULT NULL,
  `prd_compl` varchar(10) DEFAULT NULL,
  `prd_num` varchar(5) DEFAULT NULL,
  `prd_bairro` varchar(30) DEFAULT NULL,
  `prd_ddtel` varchar(11) DEFAULT NULL,
  `prd_email` varchar(40) DEFAULT NULL,
  `prd_ine` varchar(10) DEFAULT NULL,
  `trip_passenger_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cid10`
--

CREATE TABLE `cid10` (
  `id` int(11) NOT NULL,
  `code` varchar(4) NOT NULL,
  `description` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `cid10`
--

INSERT INTO `cid10` (`id`, `code`, `description`, `created_at`, `updated_at`) VALUES
(1, '000', 'Em Branco', '2025-05-29 19:28:22', '2025-05-29 19:28:22');

-- --------------------------------------------------------

--
-- Estrutura para tabela `drivers`
--

CREATE TABLE `drivers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `document` varchar(20) NOT NULL COMMENT 'CPF ou CNH',
  `license_number` varchar(20) NOT NULL COMMENT 'Número da CNH',
  `license_expiry` date NOT NULL COMMENT 'Data de validade da CNH',
  `active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `access_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `license_category` varchar(5) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('ativo','inativo','ferias','licenca') DEFAULT 'ativo',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `access_code_generated_at` timestamp NULL DEFAULT NULL,
  `access_code_status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `driver_access_codes`
--

CREATE TABLE `driver_access_codes` (
  `id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `access_code` varchar(10) NOT NULL,
  `created_at` datetime NOT NULL,
  `expires_at` datetime NOT NULL,
  `last_login` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `driver_login_log`
--

CREATE TABLE `driver_login_log` (
  `id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `login_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- --------------------------------------------------------

--
-- Estrutura para tabela `driver_per_diems`
--

CREATE TABLE `driver_per_diems` (
  `id` int(11) NOT NULL,
  `trip_id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `per_diem_type` enum('full_day','half_day','short_trip','long_trip') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_status` enum('pending','paid') DEFAULT 'pending',
  `payment_date` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `driver_per_diem_settings`
--

CREATE TABLE `driver_per_diem_settings` (
  `id` int(11) NOT NULL,
  `full_day_amount` decimal(10,2) NOT NULL COMMENT 'Valor da diária inteira',
  `half_day_amount` decimal(10,2) NOT NULL COMMENT 'Valor da meia diária',
  `use_distance_based` tinyint(1) DEFAULT 0 COMMENT 'Se verdadeiro, usa valores baseados em distância',
  `short_trip_amount` decimal(10,2) NOT NULL COMMENT 'Valor para viagens próximas',
  `long_trip_amount` decimal(10,2) NOT NULL COMMENT 'Valor para viagens distantes',
  `distance_threshold` int(11) NOT NULL DEFAULT 100 COMMENT 'Limite em KM para considerar viagem distante',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `locations`
--

CREATE TABLE `locations` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state` char(2) NOT NULL,
  `distance` int(11) NOT NULL COMMENT 'Distância em KM',
  `procedure_count` int(11) GENERATED ALWAYS AS (ceiling(`distance` / 50)) STORED COMMENT 'Quantidade de procedimentos calculados',
  `active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `zip_code` varchar(10) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('ativo','inativo') DEFAULT 'ativo',
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Estrutura para tabela `patients`
--

CREATE TABLE `patients` (
  `id` int(11) NOT NULL,
  `cns` varchar(15) NOT NULL COMMENT 'Cartão Nacional de Saúde',
  `name` varchar(100) NOT NULL,
  `birth_date` date NOT NULL,
  `sex` varchar(10) DEFAULT NULL COMMENT 'M ou F',
  `race` char(2) DEFAULT NULL COMMENT 'Código da raça/cor',
  `ethnicity` varchar(4) DEFAULT NULL,
  `nationality` varchar(3) DEFAULT NULL,
  `ibge_code` varchar(6) DEFAULT NULL COMMENT 'Código IBGE do município',
  `cep` varchar(8) DEFAULT NULL,
  `address_type` varchar(3) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `address_number` varchar(5) DEFAULT NULL,
  `address_complement` varchar(30) DEFAULT NULL,
  `neighborhood` varchar(30) DEFAULT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `whatsapp` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `zip_code` varchar(10) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `permission_name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `permissions`
--

INSERT INTO `permissions` (`id`, `permission_name`, `description`, `created_at`) VALUES
(10, 'manage_users', 'Gerenciar usuários', '2025-05-12 04:06:02'),
(11, 'manage_roles', 'Gerenciar papéis e permissões', '2025-05-12 04:06:02'),
(12, 'manage_trips', 'Gerenciar viagens', '2025-05-12 04:06:02'),
(13, 'manage_patients', 'Gerenciar pacientes', '2025-05-12 04:06:02'),
(14, 'manage_vehicles', 'Gerenciar veículos', '2025-05-12 04:06:02'),
(15, 'manage_drivers', 'Gerenciar motoristas', '2025-05-12 04:06:02'),
(16, 'manage_locations', 'Gerenciar locais', '2025-05-12 04:06:02'),
(17, 'view_reports', 'Visualizar relatórios', '2025-05-12 04:06:02'),
(18, 'manage_settings', 'Gerenciar configurações do sistema', '2025-05-12 04:06:02');

-- --------------------------------------------------------

--
-- Estrutura para tabela `procedures`
--

CREATE TABLE `procedures` (
  `id` int(11) NOT NULL,
  `code` varchar(10) NOT NULL,
  `description` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `professionals`
--

CREATE TABLE `professionals` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `cns` varchar(15) NOT NULL COMMENT 'Cartão Nacional de Saúde',
  `cbo` varchar(6) NOT NULL COMMENT 'Código Brasileiro de Ocupações',
  `active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `specialty` varchar(100) DEFAULT NULL,
  `registration_number` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('ativo','inativo') DEFAULT 'ativo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `professionals`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `role_permissions`
--

CREATE TABLE `role_permissions` (
  `id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `role_permissions`
--

INSERT INTO `role_permissions` (`id`, `role_id`, `permission_id`, `created_at`) VALUES
(1, 3, 10, '2025-05-12 04:06:42'),
(2, 3, 11, '2025-05-12 04:06:42'),
(3, 3, 12, '2025-05-12 04:06:42'),
(4, 3, 13, '2025-05-12 04:06:42'),
(5, 3, 14, '2025-05-12 04:06:42'),
(6, 3, 15, '2025-05-12 04:06:42'),
(7, 3, 16, '2025-05-12 04:06:42'),
(8, 3, 17, '2025-05-12 04:06:42'),
(9, 3, 18, '2025-05-12 04:06:42'),
(16, 2, 10, '2025-05-12 04:06:42'),
(17, 2, 12, '2025-05-12 04:06:42'),
(18, 2, 13, '2025-05-12 04:06:42'),
(19, 2, 14, '2025-05-12 04:06:42'),
(20, 2, 15, '2025-05-12 04:06:42'),
(21, 2, 16, '2025-05-12 04:06:42'),
(22, 2, 17, '2025-05-12 04:06:42'),
(23, 2, 18, '2025-05-12 04:06:42'),
(31, 1, 12, '2025-05-12 04:06:42'),
(32, 1, 13, '2025-05-12 04:06:42'),
(33, 1, 17, '2025-05-12 04:06:42');

-- --------------------------------------------------------

--
-- Estrutura para tabela `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `city_name` varchar(100) NOT NULL,
  `city_logo` mediumblob DEFAULT NULL,
  `logo_mime_type` varchar(50) DEFAULT NULL,
  `cbc_rsp` varchar(30) NOT NULL COMMENT 'Nome do órgão responsável',
  `cbc_sgl` varchar(6) NOT NULL COMMENT 'Sigla do órgão',
  `cbc_cgccpf` varchar(14) NOT NULL COMMENT 'CNPJ/CPF do prestador',
  `cbc_dst` varchar(40) NOT NULL COMMENT 'Nome do órgão de saúde destino',
  `cbc_dst_in` char(1) NOT NULL COMMENT 'Indicador do órgão destino (E/M)',
  `cbc_versao` varchar(10) NOT NULL COMMENT 'Versão do sistema',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `trips`
--

CREATE TABLE `trips` (
  `id` int(11) NOT NULL,
  `trip_date` date NOT NULL,
  `city` varchar(100) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `vehicle_id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `professional_id` int(11) NOT NULL,
  `departure_time` time NOT NULL,
  `actual_start_time` time DEFAULT NULL,
  `return_time` time DEFAULT NULL,
  `status` enum('scheduled','in_progress','completed','cancelled') DEFAULT 'scheduled',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `appointment_end_time` time DEFAULT NULL,
  `driver_notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `cancellation_reason` text DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `cancelled_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `trips`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `trip_passengers`
--

CREATE TABLE `trip_passengers` (
  `id` int(11) NOT NULL,
  `trip_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  `is_companion` tinyint(1) DEFAULT 0,
  `companion_of` int(11) DEFAULT NULL COMMENT 'ID do paciente que está acompanhando',
  `cid_id` int(11) NOT NULL,
  `notes` text DEFAULT NULL,
  `bpa_transport_generated` tinyint(1) DEFAULT 0,
  `bpa_food_generated` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `appointment_time` time DEFAULT NULL,
  `actual_end_time` time DEFAULT NULL,
  `status` varchar(20) DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `trip_passengers`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `active` int(11) NOT NULL,
  `role_id` int(11) NOT NULL DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `name`, `email`, `active`, `role_id`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'alexandre', '$2y$10$B.B5PAFAE.YexSPu/jwn3u1OSJ82yaNDCeBOeTR9bH8zR/bkHd.fu', 'Alexandre', 'alexandre@alexandre.com', 1, 3, NULL, '2025-05-22 12:46:45', '2025-05-22 12:46:45');
--Senha alexandre123
-- --------------------------------------------------------

--
-- Estrutura para tabela `user_logs`
--

CREATE TABLE `user_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(50) NOT NULL,
  `details` text DEFAULT NULL,
  `action_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `user_roles`
--

CREATE TABLE `user_roles` (
  `id` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `user_roles`
--

INSERT INTO `user_roles` (`id`, `role_name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Usuário', 'Acesso básico ao sistema', '2025-05-12 04:05:06', '2025-05-12 04:05:06'),
(2, 'Gerente', 'Acesso a recursos administrativos limitados', '2025-05-12 04:05:18', '2025-05-12 04:05:18'),
(3, 'Administrador', 'Administrador com acesso completo ao sistema', '2025-05-12 03:55:10', '2025-05-12 03:55:10'),
(4, 'usuario', 'Criador de viagens', '2025-05-12 06:52:16', '2025-05-12 06:52:16');

-- --------------------------------------------------------

--
-- Estrutura para tabela `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `plate` varchar(8) NOT NULL,
  `model` varchar(50) NOT NULL,
  `brand` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `capacity` int(11) NOT NULL COMMENT 'Capacidade de passageiros',
  `active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_activity_log_action` (`action`),
  ADD KEY `idx_activity_log_user_id` (`user_id`);

--
-- Índices de tabela `bpa_headers`
--
ALTER TABLE `bpa_headers`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `bpa_records`
--
ALTER TABLE `bpa_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `header_id` (`header_id`),
  ADD KEY `trip_passenger_id` (`trip_passenger_id`);

--
-- Índices de tabela `cid10`
--
ALTER TABLE `cid10`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Índices de tabela `drivers`
--
ALTER TABLE `drivers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `access_code` (`access_code`),
  ADD KEY `idx_drivers_access_code` (`access_code`);

--
-- Índices de tabela `driver_access_codes`
--
ALTER TABLE `driver_access_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `driver_id` (`driver_id`),
  ADD UNIQUE KEY `access_code` (`access_code`),
  ADD KEY `idx_driver_access_codes_expires` (`expires_at`);

--
-- Índices de tabela `driver_login_log`
--
ALTER TABLE `driver_login_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_driver_login_log_driver_id` (`driver_id`);

--
-- Índices de tabela `driver_per_diems`
--
ALTER TABLE `driver_per_diems`
  ADD PRIMARY KEY (`id`),
  ADD KEY `trip_id` (`trip_id`),
  ADD KEY `driver_id` (`driver_id`);

--
-- Índices de tabela `driver_per_diem_settings`
--
ALTER TABLE `driver_per_diem_settings`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cns` (`cns`);

--
-- Índices de tabela `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `procedures`
--
ALTER TABLE `procedures`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Índices de tabela `professionals`
--
ALTER TABLE `professionals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cns` (`cns`);

--
-- Índices de tabela `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_permission_unique` (`role_id`,`permission_id`),
  ADD KEY `permission_id` (`permission_id`);

--
-- Índices de tabela `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `trips`
--
ALTER TABLE `trips`
  ADD PRIMARY KEY (`id`),
  ADD KEY `location_id` (`location_id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `driver_id` (`driver_id`),
  ADD KEY `professional_id` (`professional_id`);

--
-- Índices de tabela `trip_passengers`
--
ALTER TABLE `trip_passengers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `trip_id` (`trip_id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `companion_of` (`companion_of`),
  ADD KEY `cid_id` (`cid_id`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `role_id` (`role_id`);

--
-- Índices de tabela `user_logs`
--
ALTER TABLE `user_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Índices de tabela `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `plate` (`plate`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `bpa_headers`
--
ALTER TABLE `bpa_headers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `bpa_records`
--
ALTER TABLE `bpa_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `cid10`
--
ALTER TABLE `cid10`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `drivers`
--
ALTER TABLE `drivers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de tabela `driver_access_codes`
--
ALTER TABLE `driver_access_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `driver_login_log`
--
ALTER TABLE `driver_login_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `driver_per_diems`
--
ALTER TABLE `driver_per_diems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `driver_per_diem_settings`
--
ALTER TABLE `driver_per_diem_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT de tabela `patients`
--
ALTER TABLE `patients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de tabela `procedures`
--
ALTER TABLE `procedures`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `professionals`
--
ALTER TABLE `professionals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `role_permissions`
--
ALTER TABLE `role_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de tabela `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `trips`
--
ALTER TABLE `trips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `trip_passengers`
--
ALTER TABLE `trip_passengers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `user_logs`
--
ALTER TABLE `user_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT de tabela `user_roles`
--
ALTER TABLE `user_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `bpa_records`
--
ALTER TABLE `bpa_records`
  ADD CONSTRAINT `bpa_records_ibfk_1` FOREIGN KEY (`header_id`) REFERENCES `bpa_headers` (`id`),
  ADD CONSTRAINT `bpa_records_ibfk_2` FOREIGN KEY (`trip_passenger_id`) REFERENCES `trip_passengers` (`id`);

--
-- Restrições para tabelas `driver_access_codes`
--
ALTER TABLE `driver_access_codes`
  ADD CONSTRAINT `fk_driver_access_codes_driver` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `driver_login_log`
--
ALTER TABLE `driver_login_log`
  ADD CONSTRAINT `driver_login_log_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `driver_per_diems`
--
ALTER TABLE `driver_per_diems`
  ADD CONSTRAINT `driver_per_diems_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`id`),
  ADD CONSTRAINT `driver_per_diems_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`);

--
-- Restrições para tabelas `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `user_roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `trips`
--
ALTER TABLE `trips`
  ADD CONSTRAINT `trips_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  ADD CONSTRAINT `trips_ibfk_3` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `trips_ibfk_4` FOREIGN KEY (`professional_id`) REFERENCES `professionals` (`id`);

--
-- Restrições para tabelas `trip_passengers`
--
ALTER TABLE `trip_passengers`
  ADD CONSTRAINT `trip_passengers_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`id`),
  ADD CONSTRAINT `trip_passengers_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  ADD CONSTRAINT `trip_passengers_ibfk_3` FOREIGN KEY (`companion_of`) REFERENCES `patients` (`id`),
  ADD CONSTRAINT `trip_passengers_ibfk_4` FOREIGN KEY (`cid_id`) REFERENCES `cid10` (`id`);

--
-- Restrições para tabelas `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `user_roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
