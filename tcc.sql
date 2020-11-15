--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plano; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.plano AS ENUM (
    'Básico',
    'Intermediário',
    'Avançado'
);


ALTER TYPE public.plano OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: avaliacao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avaliacao (
    empresa_id_avaliacao integer NOT NULL,
    estrela1 integer,
    estrelas2 integer,
    estrelas3 integer,
    estrelas4 integer,
    estrelas5 integer,
    nota numeric(3,2)
);


ALTER TABLE public.avaliacao OWNER TO postgres;

--
-- Name: avaliacao_final; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.avaliacao_final AS
 SELECT avaliacao.empresa_id_avaliacao,
    avaliacao.estrela1 AS nota1,
    (avaliacao.estrelas2 * 2) AS nota2,
    (avaliacao.estrelas3 * 3) AS nota3,
    (avaliacao.estrelas4 * 4) AS nota4,
    (avaliacao.estrelas5 * 5) AS nota5,
    avaliacao.nota,
    ((((avaliacao.estrela1 + (avaliacao.estrelas2 * 2)) + (avaliacao.estrelas3 * 3)) + (avaliacao.estrelas4 * 4)) + (avaliacao.estrelas5 * 5)) AS totalnota,
    ((((avaliacao.estrela1 + avaliacao.estrelas2) + avaliacao.estrelas3) + avaliacao.estrelas4) + avaliacao.estrelas5) AS qtdepessoa
   FROM public.avaliacao;


ALTER TABLE public.avaliacao_final OWNER TO postgres;

--
-- Name: cartao_pagamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cartao_pagamento (
    idcartaopagamento integer NOT NULL,
    numero_cartao character varying(19),
    cvv character varying(3),
    validade character varying(5),
    nome_cartao character varying(100) NOT NULL,
    usuario_id_cartao_pag integer NOT NULL
);


ALTER TABLE public.cartao_pagamento OWNER TO postgres;

--
-- Name: categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria (
    idcategoria integer NOT NULL,
    nome_categoria character varying(45) NOT NULL
);


ALTER TABLE public.categoria OWNER TO postgres;

--
-- Name: categoria_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria_produto (
    especie character varying(45) NOT NULL,
    raca character varying(45) NOT NULL,
    categoria_id_cat_prod integer NOT NULL,
    produto_id_cat_prod integer NOT NULL
);


ALTER TABLE public.categoria_produto OWNER TO postgres;

--
-- Name: empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empresa (
    idempresa integer NOT NULL,
    nome character varying(45) NOT NULL,
    cnpj character varying(18) NOT NULL,
    email character varying(45) NOT NULL,
    senha character varying(15) NOT NULL,
    telefone character varying(15),
    celular character varying(16) NOT NULL,
    endereco character varying(200) NOT NULL,
    numero character varying(10) NOT NULL,
    cep character varying(9) NOT NULL,
    complemento character varying(100),
    plano_escolhido public.plano NOT NULL,
    foto_perfil text,
    frete character varying(7),
    cidade character varying(150) NOT NULL,
    bairro character varying(150) NOT NULL,
    estado character varying(3) NOT NULL
);


ALTER TABLE public.empresa OWNER TO postgres;

--
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto (
    idproduto integer NOT NULL,
    nome character varying(45) NOT NULL,
    validade date,
    valor numeric(10,2) NOT NULL,
    status character varying(45) NOT NULL,
    empresa_id_produto integer NOT NULL,
    marca character varying(45),
    peso numeric(3,2) NOT NULL,
    descricao character varying(250) NOT NULL,
    unidade_medida character varying(2) NOT NULL,
    foto_principal text
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- Name: cat_prod_empresa; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cat_prod_empresa AS
 SELECT c.nome_categoria,
    cp.raca,
    cp.especie,
    p.nome AS nome_prod,
    e.idempresa,
    e.nome AS nome_empresa,
    e.foto_perfil
   FROM (((public.categoria_produto cp
     JOIN public.categoria c ON ((cp.categoria_id_cat_prod = c.idcategoria)))
     JOIN public.produto p ON ((p.idproduto = cp.produto_id_cat_prod)))
     JOIN public.empresa e ON ((e.idempresa = p.empresa_id_produto)));


ALTER TABLE public.cat_prod_empresa OWNER TO postgres;

--
-- Name: categoria_idcategoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categoria_idcategoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categoria_idcategoria_seq OWNER TO postgres;

--
-- Name: categoria_idcategoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categoria_idcategoria_seq OWNED BY public.categoria.idcategoria;


--
-- Name: empresa_idempresa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.empresa_idempresa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.empresa_idempresa_seq OWNER TO postgres;

--
-- Name: empresa_idempresa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.empresa_idempresa_seq OWNED BY public.empresa.idempresa;


--
-- Name: endereco_usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.endereco_usuario (
    idendereco integer NOT NULL,
    endereco character varying(45) NOT NULL,
    numero character varying(10) NOT NULL,
    cep character varying(10) NOT NULL,
    complemento character varying(100),
    usuario_id_endereco integer NOT NULL,
    cidade character varying(150) NOT NULL,
    bairro character varying(150) NOT NULL,
    estado character varying(3) NOT NULL
);


ALTER TABLE public.endereco_usuario OWNER TO postgres;

--
-- Name: endereco_usuario_idendereco_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.endereco_usuario_idendereco_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.endereco_usuario_idendereco_seq OWNER TO postgres;

--
-- Name: endereco_usuario_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.endereco_usuario_idendereco_seq OWNED BY public.endereco_usuario.idendereco;


--
-- Name: entregador_empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entregador_empresa (
    identregadorempresa integer NOT NULL,
    cpf_entregador character varying(14) NOT NULL,
    nome character varying(200) NOT NULL,
    celular character varying(16) NOT NULL,
    telefone character varying(16),
    empresa_id_entregador integer NOT NULL
);


ALTER TABLE public.entregador_empresa OWNER TO postgres;

--
-- Name: entregador_empresa_identregadorempresa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.entregador_empresa_identregadorempresa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entregador_empresa_identregadorempresa_seq OWNER TO postgres;

--
-- Name: entregador_empresa_identregadorempresa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.entregador_empresa_identregadorempresa_seq OWNED BY public.entregador_empresa.identregadorempresa;


--
-- Name: forma_pagamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forma_pagamento (
    idformapagamento integer NOT NULL,
    forma_pagamento character varying(17) NOT NULL,
    parcelas integer,
    valor_parcelas numeric(10,2),
    cod_barra character varying(47),
    cartao_pag_id_forma integer
);


ALTER TABLE public.forma_pagamento OWNER TO postgres;

--
-- Name: forma_pagamento_idformapagamento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.forma_pagamento_idformapagamento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.forma_pagamento_idformapagamento_seq OWNER TO postgres;

--
-- Name: forma_pagamento_idformapagamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.forma_pagamento_idformapagamento_seq OWNED BY public.forma_pagamento.idformapagamento;


--
-- Name: item_pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_pedido (
    valor_item numeric(10,2) NOT NULL,
    qtd integer NOT NULL,
    pedido_id_item integer NOT NULL,
    produto_id_item integer NOT NULL
);


ALTER TABLE public.item_pedido OWNER TO postgres;

--
-- Name: pagamento_idpagamento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pagamento_idpagamento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pagamento_idpagamento_seq OWNER TO postgres;

--
-- Name: pagamento_idpagamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pagamento_idpagamento_seq OWNED BY public.cartao_pagamento.idcartaopagamento;


--
-- Name: pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido (
    idpedido integer NOT NULL,
    total numeric(10,2) NOT NULL,
    data_pedido timestamp without time zone NOT NULL,
    previsao timestamp without time zone NOT NULL,
    empresa_id_pedido integer NOT NULL,
    usuario_id_pedido integer NOT NULL,
    forma_pagamento_id_pedido integer NOT NULL,
    entregador_empresa_id_pedido integer NOT NULL,
    endereco_usuario_id_pedido integer NOT NULL
);


ALTER TABLE public.pedido OWNER TO postgres;

--
-- Name: pedido_idpedido_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedido_idpedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pedido_idpedido_seq OWNER TO postgres;

--
-- Name: pedido_idpedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_idpedido_seq OWNED BY public.pedido.idpedido;


--
-- Name: status_pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_pedido (
    status_detalhe character varying(200) NOT NULL,
    descricao character varying(250),
    data_status timestamp without time zone NOT NULL,
    pedido_id_status integer NOT NULL,
    status character(1)
);


ALTER TABLE public.status_pedido OWNER TO postgres;

--
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    idusuario integer NOT NULL,
    cpf character varying(14) NOT NULL,
    senha character varying(15) NOT NULL,
    email character varying(45) NOT NULL,
    nascimento date NOT NULL,
    nome character varying(100) NOT NULL,
    telefone character varying(15),
    celular character varying(16) NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- Name: pedido_resumo; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.pedido_resumo AS
 SELECT p.idpedido,
    p.total,
    p.data_pedido,
    e.idempresa,
    e.nome AS nome_empresa,
    e.foto_perfil,
    u.idusuario,
    u.nome AS nome_usuario,
    enu.idendereco,
    enu.endereco,
    enu.numero,
    enu.cep,
    enu.complemento,
        CASE
            WHEN (s.status = '0'::bpchar) THEN 'desativado'::text
            ELSE 'ativo'::text
        END AS status
   FROM ((((public.pedido p
     JOIN public.status_pedido s ON ((s.pedido_id_status = p.idpedido)))
     JOIN public.empresa e ON ((e.idempresa = p.empresa_id_pedido)))
     JOIN public.usuario u ON ((u.idusuario = p.usuario_id_pedido)))
     JOIN public.endereco_usuario enu ON ((enu.usuario_id_endereco = u.idusuario)));


ALTER TABLE public.pedido_resumo OWNER TO postgres;

--
-- Name: produtos_idproduto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produtos_idproduto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produtos_idproduto_seq OWNER TO postgres;

--
-- Name: produtos_idproduto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produtos_idproduto_seq OWNED BY public.produto.idproduto;


--
-- Name: usuario_idusuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_idusuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_idusuario_seq OWNER TO postgres;

--
-- Name: usuario_idusuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_idusuario_seq OWNED BY public.usuario.idusuario;


--
-- Name: cartao_pagamento idcartaopagamento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartao_pagamento ALTER COLUMN idcartaopagamento SET DEFAULT nextval('public.pagamento_idpagamento_seq'::regclass);


--
-- Name: categoria idcategoria; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria ALTER COLUMN idcategoria SET DEFAULT nextval('public.categoria_idcategoria_seq'::regclass);


--
-- Name: empresa idempresa; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa ALTER COLUMN idempresa SET DEFAULT nextval('public.empresa_idempresa_seq'::regclass);


--
-- Name: endereco_usuario idendereco; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco_usuario ALTER COLUMN idendereco SET DEFAULT nextval('public.endereco_usuario_idendereco_seq'::regclass);


--
-- Name: entregador_empresa identregadorempresa; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entregador_empresa ALTER COLUMN identregadorempresa SET DEFAULT nextval('public.entregador_empresa_identregadorempresa_seq'::regclass);


--
-- Name: forma_pagamento idformapagamento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forma_pagamento ALTER COLUMN idformapagamento SET DEFAULT nextval('public.forma_pagamento_idformapagamento_seq'::regclass);


--
-- Name: pedido idpedido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido ALTER COLUMN idpedido SET DEFAULT nextval('public.pedido_idpedido_seq'::regclass);


--
-- Name: produto idproduto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto ALTER COLUMN idproduto SET DEFAULT nextval('public.produtos_idproduto_seq'::regclass);


--
-- Name: usuario idusuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN idusuario SET DEFAULT nextval('public.usuario_idusuario_seq'::regclass);


--
-- Data for Name: avaliacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.avaliacao (empresa_id_avaliacao, estrela1, estrelas2, estrelas3, estrelas4, estrelas5, nota) FROM stdin;
1	2	4	10	20	10	\N
2	10	5	8	21	15	\N
3	1	3	30	28	40	\N
4	200	50	77	19	12	\N
5	4	55	6	40	17	\N
\.


--
-- Data for Name: cartao_pagamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cartao_pagamento (idcartaopagamento, numero_cartao, cvv, validade, nome_cartao, usuario_id_cartao_pag) FROM stdin;
1	5466 1036 1183 1205	813	07/22	Sophie G C Ramos	3
2	4539 6701 9122 7398	255	07/21	Carla Aline Almeida	4
3	5354 9844 5097 4296	522	09/21	Aurora J M Lima	5
4	4403 1729 9663 3535	726	08/21	Calebe Pietro Araújo	6
5	3576 2935 3027 8646	952	05/21	Raimundo T R Lopes	7
\.


--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria (idcategoria, nome_categoria) FROM stdin;
1	ração
2	petisco
3	brinquedo
4	roupa
5	mala
\.


--
-- Data for Name: categoria_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria_produto (especie, raca, categoria_id_cat_prod, produto_id_cat_prod) FROM stdin;
gato	Ragdoll	1	1
cachorro	Husky Siberiano	1	2
gato	Todos	1	3
cachorro	Golden Retriever	1	4
cachorro	Todos	1	5
\.


--
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empresa (idempresa, nome, cnpj, email, senha, telefone, celular, endereco, numero, cep, complemento, plano_escolhido, foto_perfil, frete, cidade, bairro, estado) FROM stdin;
1	Joaquim e Benício Alimentos ME	00.292.228/0001-00	administracao@joaquimoalimentosme.com.br	24yy0Fq4	(11) 3528-5046	(11) 98563-4967	Rua Padre Feliciano Grande	576	12942-460	Empresa de alimentos	Básico	foto_1	grátis	Atibaia	Alvinópolis	SP
2	Luís e Igor Mudanças Ltda	03.433.643/0001-17	administracao@igormudancas.com.br	mujQuub0	(19) 3672-5672	(19) 99852-1896	Rua Antonio Gil de Oliveira	773	13401-135	Empresa de mudança	Intermediário	foto_2	grátis	Piracicaba	Paulista	SP
3	Danilo e Marli Lavanderia ME	47.130.085/0001-96	ti@danilolavanderiame.com.br	I53il6lb	(11) 2567-9910	(11) 99671-9717	Rua Joaquim Dias	356	05836-270	Empresa de lavanderia	Avançado	foto_3	grátis	São Paulo	Jardim Monte Azul	SP
4	Clara e Pietro Telecomunicações Ltda	48.598.346/0001-60	diretoria@claratelecom.com.br	Fu4plEie	(11) 2954-1573	(11) 99220-1045	Rua Panorama	456	13238-531	Empresa de telecomunicações	Básico	foto_4	grátis	Campo Limpo Paulista	Vila Constança	SP
5	Bárbara e Cláudio Contábil ME	79.689.345/0001-54	orcamento@barbaracontabil.com.br	9WSzbAtD	(15) 2959-9479	(15) 99585-3897	Rua Gonçalves Dias	504	18081-040	Empresa de contabilidade	Básico	foto_5	5,00	Sorocaba	Vila Gabriel	SP
6	Petitos	95.833.009/0001-90	contato@petitos.com.br	petitos123	(11) 3923-2401	(11) 98979-3003	Praça Uirapuru	489	05675-030	Casa de Ração	Básico	foto_6	\N	São Paulo	Cidade Jardim	SP
7	Bigodinho Pets	57.463.932/0001-98	adm@bigodinhopets.com	francalinopets	(11) 4568-1265	(11) 98456-5213	Av. João Batista Medina	79	06803-445	Casa de Ração do Francalino	Intermediário	foto_7	\N	Embu das Artes	Centro	SP
8	PetLove	65.154.265/0001-25	contato@ptlove.com	petinhoslovitos	(11) 2564-4569	(11) 95684-2356	Rua Sylvio Zanelato	77	06767110		Intermediário	foto_8	\N	Taboão da Serra	Pq.Pinheiros	SP
9	PetStore	54.985.654/0001-37	adm@petstore.com	petloja	(11) 3256-4587	(11) 96541-2364	Rua Saturno	56	06840-080		Avançado	foto_9	\N	Embu das Artes	Jd. Novo Embu	SP
21	Pet Life	11.008.984/0001-73	contato@ptlife.com	vidapet	(11) 2632-8164	(11) 98853-9437	Rua Salvador Caruso	927	05054-060		Básico	foto_21	\N	São Paulo	Vila Ipojuca	SP
23	Vida Pet	98.650.958/0001-22	adm@vidapet.com	petvida	(17) 3570-5543	(17) 99411-9215	Rodovia Armando de Salles Oliveira km 595,501	403	14707-900		Básico	foto_23	\N	Bebedouro	Jardim do Bosque	SP
\.


--
-- Data for Name: endereco_usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.endereco_usuario (idendereco, endereco, numero, cep, complemento, usuario_id_endereco, cidade, bairro, estado) FROM stdin;
1	Rua Monte Denali	367	69092-425	Rua sem saída	3	Manaus	Nova Cidade	AM
2	Rua José Estevam Souza	817	56310-240	Casa 5	4	Petrolina	COHAB Massangano	PE
3	Quadra SQ 19 Quadra 12	168	72880-714	Loja de roupa	5	Cidade Ocidental	Centro	GO
4	Rua Pequi	315	79115-160	Casa 3	6	Campo Grande	Coophatrabalho	MS
5	Travessa B	435	49096-277	Rua sem saída	7	Aracaju	Jabotiana	SE
\.


--
-- Data for Name: entregador_empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entregador_empresa (identregadorempresa, cpf_entregador, nome, celular, telefone, empresa_id_entregador) FROM stdin;
1	471.045.284-90	Heloisa Marina Rayssa Castro	(95) 98730-6310	(95) 3639-9633	1
2	942.006.114-06	Sebastiana Teresinha Caldeira	(51) 99906-5059	(51) 2713-8864	2
3	617.772.722-03	Tiago Augusto Souza	(11) 98996-4176	(11) 3689-2561	3
4	597.552.729-50	Henrique João Oliveira	(27) 98164-1797	(27) 2751-7483	4
5	606.357.045-44	Carla Cláudia Aparecida Nogueira	(21) 98808-2710	(21) 2878-2294	5
\.


--
-- Data for Name: forma_pagamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.forma_pagamento (idformapagamento, forma_pagamento, parcelas, valor_parcelas, cod_barra, cartao_pag_id_forma) FROM stdin;
1	Dinheiro	\N	\N	\N	\N
2	Cartão de Crédito	3	30.00	\N	1
3	Cartão de Débito	\N	\N	\N	2
4	Dinheiro	\N	\N	\N	\N
5	Cartão de Crédito	2	9.00	\N	3
\.


--
-- Data for Name: item_pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_pedido (valor_item, qtd, pedido_id_item, produto_id_item) FROM stdin;
20.00	2	2	1
30.00	3	3	2
22.00	3	4	3
15.00	1	5	4
18.00	2	6	5
20.00	2	7	1
\.


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido (idpedido, total, data_pedido, previsao, empresa_id_pedido, usuario_id_pedido, forma_pagamento_id_pedido, entregador_empresa_id_pedido, endereco_usuario_id_pedido) FROM stdin;
2	40.00	2020-09-25 00:00:00	2020-09-25 00:00:00	1	6	1	1	4
4	66.00	2020-10-09 00:00:00	2020-10-10 00:00:00	3	4	3	3	2
5	15.00	2020-09-25 00:00:00	2020-09-26 00:00:00	2	7	4	2	5
6	18.00	2020-10-01 00:00:00	2020-10-01 00:00:00	4	5	5	4	3
7	40.00	2020-11-13 17:59:54	2020-11-13 18:59:00	1	3	1	1	3
3	95.00	2020-10-26 00:00:00	2020-10-26 00:00:00	5	3	2	5	1
\.


--
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto (idproduto, nome, validade, valor, status, empresa_id_produto, marca, peso, descricao, unidade_medida, foto_principal) FROM stdin;
1	sabor carne	2021-12-21	20.00	disponível	1	Golden	2.00	ração de carne Golden para gatos	kg	\N
3	sabor salmão	2026-10-19	22.00	disponível	3	Whiskas	1.00	ração de salmão Whiskas para gatos	kg	\N
4	sabor fígado	2023-07-25	15.00	indisponível	2	Guaby	1.00	ração de fígado Guaby para cachorros	kg	\N
2	sabor frango	2022-05-16	30.00	disponível	5	Premier	5.00	ração de frango Premier para cachorros	kg	\N
5	sabor peito de peru	2021-12-15	18.00	indisponível	4	Fórmula Natural	2.00	ração de peito de peru Fórmula Natural para cachorros	kg	\N
\.


--
-- Data for Name: status_pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_pedido (status_detalhe, descricao, data_status, pedido_id_status, status) FROM stdin;
em separação	separando o produto pedido	2020-09-25 00:00:00	2	1
em separação	separando o produto pedido	2020-10-26 00:00:00	3	1
a caminho	a caminho do cliente	2020-10-09 00:00:00	4	1
entregue	pedido foi entregue ao cliente	2020-09-25 00:00:00	5	0
em separação	separando o produto pedido	2020-10-01 00:00:00	6	1
em separação	separando o produto pedido	2020-11-13 00:00:00	7	1
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (idusuario, cpf, senha, email, nascimento, nome, telefone, celular) FROM stdin;
3	089.703.487-27	d21Ym3tGse	sophiegiovannaclariceramos@gamil.com	1974-02-19	Sophie Giovanna Clarice Ramos	(92) 3585-1880	(92) 98531-9989
4	837.147.127-04	0JbmS4YaLJ	carlaalinealmeida@live.jp	1987-05-01	Carla Aline Almeida	(87) 3892-2532	(87) 98716-9531
5	166.226.857-20	cTGGlWsc7d	aaurorajuliamilenalima@numero.com.br	1999-09-05	Aurora Julia Milena Lima	(61) 2852-8566	(61) 99892-8514
6	347.532.777-55	wKneu6uerd	calebepietroaraujo-92@agacapital.com.br	1984-08-16	Calebe Pietro Araújo	(67) 3510-2967	(67) 99599-4081
7	460.465.446-88	gIBhioE9Gu	raimundotomasricardolopes@me.com	2001-09-06	Raimundo Tomás Ricardo Lopes	(79) 2789-9452	(79) 99400-4973
\.


--
-- Name: categoria_idcategoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_idcategoria_seq', 5, true);


--
-- Name: empresa_idempresa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empresa_idempresa_seq', 38, true);


--
-- Name: endereco_usuario_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.endereco_usuario_idendereco_seq', 5, true);


--
-- Name: entregador_empresa_identregadorempresa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.entregador_empresa_identregadorempresa_seq', 5, true);


--
-- Name: forma_pagamento_idformapagamento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.forma_pagamento_idformapagamento_seq', 5, true);


--
-- Name: pagamento_idpagamento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pagamento_idpagamento_seq', 5, true);


--
-- Name: pedido_idpedido_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_idpedido_seq', 7, true);


--
-- Name: produtos_idproduto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produtos_idproduto_seq', 5, true);


--
-- Name: usuario_idusuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_idusuario_seq', 7, true);


--
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (idcategoria);


--
-- Name: empresa empresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (idempresa);


--
-- Name: endereco_usuario endereco_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco_usuario
    ADD CONSTRAINT endereco_usuario_pkey PRIMARY KEY (idendereco);


--
-- Name: entregador_empresa entregador_empresa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entregador_empresa
    ADD CONSTRAINT entregador_empresa_pkey PRIMARY KEY (identregadorempresa);


--
-- Name: forma_pagamento forma_pagamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forma_pagamento
    ADD CONSTRAINT forma_pagamento_pkey PRIMARY KEY (idformapagamento);


--
-- Name: cartao_pagamento pagamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartao_pagamento
    ADD CONSTRAINT pagamento_pkey PRIMARY KEY (idcartaopagamento);


--
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (idpedido);


--
-- Name: produto produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (idproduto);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (idusuario);


--
-- Name: forma_pagamento cartao_pag_id_forma; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forma_pagamento
    ADD CONSTRAINT cartao_pag_id_forma FOREIGN KEY (cartao_pag_id_forma) REFERENCES public.cartao_pagamento(idcartaopagamento);


--
-- Name: categoria_produto categoria_id_cat_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_produto
    ADD CONSTRAINT categoria_id_cat_prod FOREIGN KEY (categoria_id_cat_prod) REFERENCES public.categoria(idcategoria);


--
-- Name: avaliacao empresa_id_avaliacao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacao
    ADD CONSTRAINT empresa_id_avaliacao FOREIGN KEY (empresa_id_avaliacao) REFERENCES public.empresa(idempresa);


--
-- Name: entregador_empresa empresa_id_entregador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entregador_empresa
    ADD CONSTRAINT empresa_id_entregador FOREIGN KEY (empresa_id_entregador) REFERENCES public.empresa(idempresa);


--
-- Name: pedido empresa_id_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT empresa_id_pedido FOREIGN KEY (empresa_id_pedido) REFERENCES public.empresa(idempresa);


--
-- Name: produto empresa_id_produto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT empresa_id_produto FOREIGN KEY (empresa_id_produto) REFERENCES public.empresa(idempresa);


--
-- Name: pedido endereco_usuario_id_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT endereco_usuario_id_pedido FOREIGN KEY (endereco_usuario_id_pedido) REFERENCES public.endereco_usuario(idendereco);


--
-- Name: pedido entregador_empresa_id_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT entregador_empresa_id_pedido FOREIGN KEY (entregador_empresa_id_pedido) REFERENCES public.entregador_empresa(identregadorempresa);


--
-- Name: pedido forma_pagamento_id_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT forma_pagamento_id_pedido FOREIGN KEY (forma_pagamento_id_pedido) REFERENCES public.forma_pagamento(idformapagamento);


--
-- Name: item_pedido pedido_id_item; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_pedido
    ADD CONSTRAINT pedido_id_item FOREIGN KEY (pedido_id_item) REFERENCES public.pedido(idpedido);


--
-- Name: status_pedido pedido_id_status; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_pedido
    ADD CONSTRAINT pedido_id_status FOREIGN KEY (pedido_id_status) REFERENCES public.pedido(idpedido);


--
-- Name: categoria_produto produto_id_cat_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_produto
    ADD CONSTRAINT produto_id_cat_prod FOREIGN KEY (produto_id_cat_prod) REFERENCES public.produto(idproduto);


--
-- Name: item_pedido produto_id_item; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_pedido
    ADD CONSTRAINT produto_id_item FOREIGN KEY (produto_id_item) REFERENCES public.produto(idproduto);


--
-- Name: cartao_pagamento usuario_id_cartao_pag; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartao_pagamento
    ADD CONSTRAINT usuario_id_cartao_pag FOREIGN KEY (usuario_id_cartao_pag) REFERENCES public.usuario(idusuario);


--
-- Name: endereco_usuario usuario_id_endereco; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco_usuario
    ADD CONSTRAINT usuario_id_endereco FOREIGN KEY (usuario_id_endereco) REFERENCES public.usuario(idusuario);


--
-- Name: pedido usuario_id_pedido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT usuario_id_pedido FOREIGN KEY (usuario_id_pedido) REFERENCES public.usuario(idusuario);


--
-- PostgreSQL database dump complete
--

