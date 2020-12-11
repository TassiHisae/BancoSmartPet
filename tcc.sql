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
-- Name: forma_pagamento; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.forma_pagamento AS ENUM (
    'Dinheiro',
    'Crédito',
    'Débito'
);


ALTER TYPE public.forma_pagamento OWNER TO postgres;

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
    categoria_id_cat_prod integer NOT NULL,
    produto_id_cat_prod integer NOT NULL,
    raca_id_cat_prod integer
);


ALTER TABLE public.categoria_produto OWNER TO postgres;

--
-- Name: especie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especie (
    idespecie integer NOT NULL,
    nome_especie character varying(100) NOT NULL
);


ALTER TABLE public.especie OWNER TO postgres;

--
-- Name: raca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.raca (
    idraca integer NOT NULL,
    nome_raca character varying(100) NOT NULL,
    especie_id_raca integer NOT NULL
);


ALTER TABLE public.raca OWNER TO postgres;

--
-- Name: cat_prod_cad; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cat_prod_cad AS
 SELECT cp.categoria_id_cat_prod,
    cp.raca_id_cat_prod,
    cp.produto_id_cat_prod,
    c.nome_categoria,
    r.nome_raca,
    r.especie_id_raca,
    e.nome_especie
   FROM (((public.categoria_produto cp
     JOIN public.raca r ON ((r.idraca = cp.raca_id_cat_prod)))
     JOIN public.especie e ON ((e.idespecie = r.especie_id_raca)))
     JOIN public.categoria c ON ((c.idcategoria = cp.categoria_id_cat_prod)));


ALTER TABLE public.cat_prod_cad OWNER TO postgres;

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
    estado character varying(2) NOT NULL
);


ALTER TABLE public.empresa OWNER TO postgres;

--
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto (
    idproduto integer NOT NULL,
    nome character varying(45) NOT NULL,
    valor integer NOT NULL,
    status character varying(45) NOT NULL,
    empresa_id_produto integer NOT NULL,
    marca character varying(45),
    peso integer NOT NULL,
    descricao character varying(250),
    unidade_medida character varying(2) NOT NULL,
    foto_principal text
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- Name: cat_prod_empresa; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cat_prod_empresa AS
 SELECT c.nome_categoria,
    r.nome_raca AS raca,
    es.nome_especie AS especie,
    p.nome AS nome_prod,
    p.idproduto,
    p.foto_principal,
    p.valor,
    p.marca,
    p.descricao,
    p.peso,
    p.unidade_medida,
    e.idempresa,
    e.nome AS nome_empresa,
    e.foto_perfil,
    e.frete
   FROM (((((public.categoria c
     JOIN public.categoria_produto cp ON ((cp.categoria_id_cat_prod = c.idcategoria)))
     JOIN public.produto p ON ((p.idproduto = cp.produto_id_cat_prod)))
     JOIN public.empresa e ON ((e.idempresa = p.empresa_id_produto)))
     JOIN public.raca r ON ((r.idraca = cp.raca_id_cat_prod)))
     JOIN public.especie es ON ((es.idespecie = r.especie_id_raca)));


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
    estado character varying(2) NOT NULL,
    status character(1) NOT NULL
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
-- Name: especie_idespecie_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.especie_idespecie_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.especie_idespecie_seq OWNER TO postgres;

--
-- Name: especie_idespecie_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.especie_idespecie_seq OWNED BY public.especie.idespecie;


--
-- Name: item_pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_pedido (
    valor_item integer NOT NULL,
    qtd integer NOT NULL,
    pedido_id_item integer NOT NULL,
    produto_id_item integer NOT NULL
);


ALTER TABLE public.item_pedido OWNER TO postgres;

--
-- Name: lista_pedido_produto; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.lista_pedido_produto AS
 SELECT ip.pedido_id_item AS idpedido,
    ip.qtd,
    p.nome,
    p.descricao
   FROM (public.item_pedido ip
     JOIN public.produto p ON ((p.idproduto = ip.produto_id_item)));


ALTER TABLE public.lista_pedido_produto OWNER TO postgres;

--
-- Name: pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido (
    idpedido integer NOT NULL,
    total integer NOT NULL,
    data_pedido timestamp without time zone NOT NULL,
    previsao timestamp without time zone,
    empresa_id_pedido integer NOT NULL,
    usuario_id_pedido integer NOT NULL,
    endereco_usuario_id_pedido integer NOT NULL,
    idusuario_pedidos character varying(255) NOT NULL,
    status character(1) NOT NULL,
    forma_pagamento public.forma_pagamento NOT NULL
);


ALTER TABLE public.pedido OWNER TO postgres;

--
-- Name: parcerias; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.parcerias AS
 SELECT p.empresa_id_pedido,
    count(p.empresa_id_pedido) AS pedidos,
    e.nome,
    e.foto_perfil
   FROM (public.pedido p
     JOIN public.empresa e ON ((e.idempresa = p.empresa_id_pedido)))
  GROUP BY p.empresa_id_pedido, e.nome, e.foto_perfil
  ORDER BY (count(p.empresa_id_pedido)) DESC
 LIMIT 6;


ALTER TABLE public.parcerias OWNER TO postgres;

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
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    idusuario integer NOT NULL,
    cpf character varying(14) NOT NULL,
    senha character varying(15) NOT NULL,
    email character varying(45) NOT NULL,
    nascimento date NOT NULL,
    nome character varying(100) NOT NULL,
    celular2 character varying(16),
    celular character varying(16) NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- Name: pedido_resumo; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.pedido_resumo AS
 SELECT p.idpedido,
    p.total,
    to_char(p.data_pedido, 'dd/mm/yyyy hh24:mi'::text) AS data_pedido,
    to_char(p.previsao, 'dd/mm/yyyy'::text) AS data_previsao,
    to_char(p.previsao, 'hh24:mi'::text) AS hora_previsao,
    e.idempresa,
    e.nome AS nome_empresa,
    e.foto_perfil,
    u.idusuario,
    u.nome AS nome_usuario,
    u.celular,
    u.celular2,
    enu.idendereco,
    enu.endereco,
    enu.numero,
    enu.cep,
    enu.bairro,
    enu.cidade,
    enu.estado,
    enu.complemento,
        CASE
            WHEN (p.status = '0'::bpchar) THEN 'inativo'::text
            ELSE 'ativo'::text
        END AS status
   FROM (((public.pedido p
     JOIN public.empresa e ON ((e.idempresa = p.empresa_id_pedido)))
     JOIN public.usuario u ON ((u.idusuario = p.usuario_id_pedido)))
     JOIN public.endereco_usuario enu ON ((enu.usuario_id_endereco = u.idusuario)))
  ORDER BY p.idpedido;


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
-- Name: raca_idraca_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.raca_idraca_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.raca_idraca_seq OWNER TO postgres;

--
-- Name: raca_idraca_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.raca_idraca_seq OWNED BY public.raca.idraca;


--
-- Name: status_pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_pedido (
    status_detalhe character varying(200) NOT NULL,
    descricao character varying(250),
    data_status timestamp without time zone NOT NULL,
    pedido_id_status integer NOT NULL
);


ALTER TABLE public.status_pedido OWNER TO postgres;

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
-- Name: especie idespecie; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especie ALTER COLUMN idespecie SET DEFAULT nextval('public.especie_idespecie_seq'::regclass);


--
-- Name: pedido idpedido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido ALTER COLUMN idpedido SET DEFAULT nextval('public.pedido_idpedido_seq'::regclass);


--
-- Name: produto idproduto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto ALTER COLUMN idproduto SET DEFAULT nextval('public.produtos_idproduto_seq'::regclass);


--
-- Name: raca idraca; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raca ALTER COLUMN idraca SET DEFAULT nextval('public.raca_idraca_seq'::regclass);


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
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria (idcategoria, nome_categoria) FROM stdin;
1	Alimentos
2	Acessórios
3	Saúde
4	Utensílios
5	Brinquedos
\.


--
-- Data for Name: categoria_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria_produto (categoria_id_cat_prod, produto_id_cat_prod, raca_id_cat_prod) FROM stdin;
1	37	4
3	36	27
2	35	27
1	38	7
2	38	27
2	42	27
1	6	2
1	1	27
1	4	7
3	3	28
2	5	26
1	2	30
1	44	14
2	43	28
\.


--
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empresa (idempresa, nome, cnpj, email, senha, telefone, celular, endereco, numero, cep, complemento, plano_escolhido, foto_perfil, frete, cidade, bairro, estado) FROM stdin;
6	Petitos	95.833.009/0001-90	contato@petitos.com.br	petitos123	(11) 3923-2401	(11) 98979-3003	Praça Uirapuru	489	05675-030	Casa de Ração	Básico	foto_6.jpg	\N	São Paulo	Cidade Jardim	SP
39	Tom Pets	69.478.846/0001-38	tompet@hotmail.com	mozao		(11) 99669-2487	Rua Asdrubal Zanetti	232	07196-210	Casa 5	Básico	empresa_39.jpeg	10,00	Guarulhos	Jardim Bom Clima	SP
42	Ragtom	21.458.745/0001-28	ragtom@outlook.com	ragtom	(11)  5657-4236	(11) 9 4587-4569	Rua José Germano	853	12285-460	Casa 2	Avançado	\N	\N	Caçapava	Residencial Esperança	SP
44	Tom 21	54.869.541/0001-22	21tom@gmail.com	tom21	(11)  2564-7996	(11) 9 5478-5632	Rua José Germano	358	12285-460	Casa 2	Básico	empresa_44.jpeg	10,00	Caçapava	Residencial Esperança	SP
1	M & T	00.292.228/0001-00	casaracao@mt.com.br	m&t	(11) 3528-5046	(11) 98563-4967	Rua Padre Feliciano Grande	576	12942-460	Empresa de alimentos	Básico	foto_1.jpg	grátis	Atibaia	Alvinópolis	SP
2	Golden	03.433.643/0001-17	administracao@golden.com.br	golden	(19) 3672-5672	(19) 99852-1896	Rua Antonio Gil de Oliveira	773	13401-135	Empresa de mudança	Intermediário	foto_2.jpg	grátis	Piracicaba	Paulista	SP
3	Rações TOP	47.130.085/0001-96	top@topracao.com.br	top	(11) 2567-9910	(11) 99671-9717	Rua Joaquim Dias	356	05836-270	Empresa de lavanderia	Avançado	foto_3.jpg	0	São Paulo	Jardim Monte Azul	SP
4	Pedigree	48.598.346/0001-60	pedigree@pedigree.com.br	pedigree	(11) 2954-1573	(11) 99220-1045	Rua Panorama	456	13238-531	Empresa de telecomunicações	Básico	foto_4.jpg	grátis	Campo Limpo Paulista	Vila Constança	SP
5	Foster	79.689.345/0001-54	foster@foster.com.br	foster	(15) 2959-9479	(15) 99585-3897	Rua Gonçalves Dias	504	18081-040	Empresa de contabilidade	Básico	foto_5.jpg	5,00	Sorocaba	Vila Gabriel	SP
\.


--
-- Data for Name: endereco_usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.endereco_usuario (idendereco, endereco, numero, cep, complemento, usuario_id_endereco, cidade, bairro, estado, status) FROM stdin;
1	Rua Monte Denali	367	69092-425	Rua sem saída	3	Manaus	Nova Cidade	AM	1
2	Rua José Estevam Souza	817	56310-240	Casa 5	4	Petrolina	COHAB Massangano	PE	1
3	Quadra SQ 19 Quadra 12	168	72880-714	Loja de roupa	5	Cidade Ocidental	Centro	GO	1
4	Rua Pequi	315	79115-160	Casa 3	6	Campo Grande	Coophatrabalho	MS	1
5	Travessa B	435	49096-277	Rua sem saída	7	Aracaju	Jabotiana	SE	1
\.


--
-- Data for Name: especie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especie (idespecie, nome_especie) FROM stdin;
1	Todos
2	Gato
3	Cachorro
4	Pássaro
5	Peixe
6	Coelho
\.


--
-- Data for Name: item_pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_pedido (valor_item, qtd, pedido_id_item, produto_id_item) FROM stdin;
2000	2	2	1
3000	3	3	2
2200	3	4	3
1500	1	5	4
1800	2	6	5
2000	1	7	1
2000	1	7	1
1000	2	8	6
\.


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido (idpedido, total, data_pedido, previsao, empresa_id_pedido, usuario_id_pedido, endereco_usuario_id_pedido, idusuario_pedidos, status, forma_pagamento) FROM stdin;
2	40	2020-09-25 00:00:00	2020-09-25 00:00:00	1	6	4	6_1	1	Dinheiro
3	95	2020-10-26 00:00:00	2020-10-26 00:00:00	5	3	1	3_1	1	Dinheiro
5	15	2020-09-25 00:00:00	2020-09-26 00:00:00	2	7	5	7_1	0	Dinheiro
4	66	2020-10-09 00:00:00	2020-10-10 00:00:00	3	4	2	4_1	1	Crédito
6	18	2020-10-01 00:00:00	2020-10-01 00:00:00	4	5	3	5_1	1	Crédito
7	40	2020-11-13 17:59:54	2020-11-13 18:59:00	1	3	3	3_2	1	Débito
8	20	2020-11-20 11:11:00	2020-11-21 12:00:00	39	7	5	7_2	0	Débito
\.


--
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto (idproduto, nome, valor, status, empresa_id_produto, marca, peso, descricao, unidade_medida, foto_principal) FROM stdin;
2	Ração para peixe	3000	disponível	5	NutraFish	15000	- Contém proteínas e vitaminas;\n- Auxilia o desenvolvimento;\n- Realça a cor.	g	Produto_2.jpeg
44	Ração para pássaro	2000	disponível	6	NutriBird	2000	 Formulado com ingredientes de alta qualidade e digestibilidade, enriquecido com vitaminas e minerais, proporcionando uma vida saudavel às aves	g	produto44_6.jpeg
37	Ração Carne	1500	disponível	39	Special Dog	1000	Ração de carne Golden Ragdoll	kg	produto37_39.jpeg
43	Fantasia Hot Dog	10000	disponível	44	Special Dog	10000	Roupinha de hot dog para cachorros	g	produto43_44.jpeg
6	Petisco	1000	disponível	39	\N	700	Petisco petitos	kg	produto15_39.jpeg
36	Drontal	5450	indisponível	39	Bayer	33900	O Vermífugo Drontal Gatos é indicado para o tratamento e controle das verminoses intestinais em gatos	mg	produto36_39.jpeg
35	Bigodinho Pets	1000	indisponível	39	Golden	1000	Ração de frango Special Dog para Golden	kg	produto35_39.jpeg
38	Ração Carne	1000	disponível	39	Special Dog	1000	Ração de carne Special Dog para Pastor	kg	produto38_39.webp
42	Fantasia Dinossauro	10000	disponível	42	Special Cat	3000	Roupinha de dinossauro para gatos	g	produto42_42.webp
1	sabor carne	2000	disponível	1	Golden	300	ração de carne Golden para gatos	kg	Produto_1.jpeg
4	sabor cordeiro e aveia	5000	indisponível	2	Guaby Natural	1500	ração de cordeiro e aveia Guaby para Pastor-Alemão	kg	Produto_4.webp
3	Antipulgas Zoetis	7000	disponível	3	Simparic	4000	para Cães 10,1 a 20 Kg utilizado para o tratamento das infestações por pulgas e sarna sarcótica. Após a administração do Simparic, a sua atividade contra pulgas dura, pelo menos, 5 semanas	mg	Produto_3.jpeg
5	Bandana Para Coelho	1800	disponível	4	Coelhinhos	1000	Acessórios para coelhos feito exclusivamente para eles.\nServe em anão.	g	Produto_5.webp
\.


--
-- Data for Name: raca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.raca (idraca, nome_raca, especie_id_raca) FROM stdin;
1	Todos	1
2	Persa	2
3	Siamês	2
4	Ragdoll	2
5	Maine Coon	2
6	Sphynx	2
7	Pastor-Alemão	3
8	Buldogue	3
9	Poodle	3
10	Golden Retriever	3
11	Maltês	3
12	Arara	4
13	Calopsita	4
14	Canário	4
15	Coleiro	4
16	Papagaio	4
17	Trichogaster leeri	5
18	Platy	5
19	Paulistinha	5
20	Tetra Preto	5
21	Neon Cardina	5
22	Rex	6
23	Holland Lop	6
24	Cabeça de Leão	6
25	Angorá Inglês	6
26	Anão Holandês	6
27	Todos	2
28	Todos	3
29	Todos	4
30	Todos	5
31	Todos	6
\.


--
-- Data for Name: status_pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_pedido (status_detalhe, descricao, data_status, pedido_id_status) FROM stdin;
a caminho	a caminho do cliente	2020-10-09 00:00:00	4
Pedido Aceito	\N	2020-11-19 22:35:00	7
Em Separação	separando o produto pedido	2020-09-25 00:00:00	2
Em Separação	separando o produto pedido	2020-10-26 00:00:00	3
Em Separação	separando o produto pedido	2020-10-01 00:00:00	6
Em Separação	separando o produto pedido	2020-11-13 00:00:00	7
Entregue	pedido foi entregue ao cliente	2020-09-25 00:00:00	5
Pedido Aceito	\N	2020-12-09 12:06:00	8
Em Separação	\N	2020-12-09 12:06:00	8
Saiu para entrega	\N	2020-12-09 12:06:00	8
Entregue	\N	2020-12-09 12:11:00	8
Pedido Aceito	\N	2020-12-11 10:51:00	2
Pedido Aceito	\N	2020-12-11 11:01:00	4
Pedido Aceito	\N	2020-12-11 11:18:00	6
Pedido Aceito	\N	2020-12-11 11:23:00	3
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (idusuario, cpf, senha, email, nascimento, nome, celular2, celular) FROM stdin;
3	089.703.487-27	d21Ym3tGse	sophiegiovannaclariceramos@gamil.com	1974-02-19	Sophie Giovanna Clarice Ramos	(92) 3585-1880	(92) 98531-9989
4	837.147.127-04	0JbmS4YaLJ	carlaalinealmeida@live.jp	1987-05-01	Carla Aline Almeida	(87) 3892-2532	(87) 98716-9531
5	166.226.857-20	cTGGlWsc7d	aaurorajuliamilenalima@numero.com.br	1999-09-05	Aurora Julia Milena Lima	(61) 2852-8566	(61) 99892-8514
7	460.465.446-88	gIBhioE9Gu	raimundotomasricardolopes@me.com	2001-09-06	Raimundo Tomás Ricardo Lopes	(79) 2789-9452	(79) 99400-4973
6	347.532.777-55	123	jonathankitagawa@hotmail.com.br	1984-08-16	Calebe Pietro Araújo	(67) 3510-2967	(67) 99599-4081
\.


--
-- Name: categoria_idcategoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_idcategoria_seq', 5, true);


--
-- Name: empresa_idempresa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empresa_idempresa_seq', 44, true);


--
-- Name: endereco_usuario_idendereco_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.endereco_usuario_idendereco_seq', 5, true);


--
-- Name: especie_idespecie_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.especie_idespecie_seq', 6, true);


--
-- Name: pedido_idpedido_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_idpedido_seq', 8, true);


--
-- Name: produtos_idproduto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produtos_idproduto_seq', 44, true);


--
-- Name: raca_idraca_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.raca_idraca_seq', 31, true);


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
-- Name: especie especie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especie
    ADD CONSTRAINT especie_pkey PRIMARY KEY (idespecie);


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
-- Name: raca raca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raca
    ADD CONSTRAINT raca_pkey PRIMARY KEY (idraca);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (idusuario);


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
-- Name: raca especie_id_raca; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raca
    ADD CONSTRAINT especie_id_raca FOREIGN KEY (especie_id_raca) REFERENCES public.especie(idespecie);


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
-- Name: categoria_produto raca_id_cat_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_produto
    ADD CONSTRAINT raca_id_cat_prod FOREIGN KEY (raca_id_cat_prod) REFERENCES public.raca(idraca);


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

