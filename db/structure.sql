--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    namespace character varying(255),
    body text,
    resource_id character varying(255) NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    resource_creator_id integer
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: api_clients; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE api_clients (
    id integer NOT NULL,
    name character varying(255),
    description text,
    app_token character varying(255),
    valid boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: api_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE api_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE api_clients_id_seq OWNED BY api_clients.id;


--
-- Name: brands; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE brands (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying(255),
    creator_id integer
);


--
-- Name: brands_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE brands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE brands_id_seq OWNED BY brands.id;


--
-- Name: category_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE category_groups (
    id integer NOT NULL,
    name character varying(255),
    gender character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: category_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE category_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE category_groups_id_seq OWNED BY category_groups.id;


--
-- Name: category_groups_product_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE category_groups_product_categories (
    category_group_id integer,
    product_category_id integer
);


--
-- Name: character_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE character_images (
    id integer NOT NULL,
    url text,
    alt_text character varying(255),
    thumbnail boolean,
    character_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    cover boolean,
    verified boolean
);


--
-- Name: character_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE character_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: character_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE character_images_id_seq OWNED BY character_images.id;


--
-- Name: characters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE characters (
    id integer NOT NULL,
    name character varying(255),
    show_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying(255),
    description text,
    actor character varying(255),
    gender character varying(255),
    importance integer,
    verified boolean,
    approved boolean DEFAULT false,
    guest boolean DEFAULT false,
    deleted_at timestamp without time zone,
    flag boolean,
    creator_id integer,
    movie_id integer,
    featured boolean
);


--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE characters_id_seq OWNED BY characters.id;


--
-- Name: colors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE colors (
    id integer NOT NULL,
    name character varying(255),
    color_code character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: colors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE colors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: colors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE colors_id_seq OWNED BY colors.id;


--
-- Name: colors_products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE colors_products (
    color_id integer,
    product_id integer
);


--
-- Name: comment_flags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comment_flags (
    id integer NOT NULL,
    comment_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: comment_flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comment_flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comment_flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comment_flags_id_seq OWNED BY comment_flags.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    user_id integer,
    commentable_id integer,
    commentable_type character varying(255),
    body character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: directors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE directors (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: directors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE directors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE directors_id_seq OWNED BY directors.id;


--
-- Name: directors_movies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE directors_movies (
    movie_id integer NOT NULL,
    director_id integer NOT NULL
);


--
-- Name: durations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE durations (
    id integer NOT NULL,
    start_time integer,
    end_time integer,
    scene_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    verified boolean
);


--
-- Name: durations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE durations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: durations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE durations_id_seq OWNED BY durations.id;


--
-- Name: episode_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE episode_images (
    id integer NOT NULL,
    episode_id integer,
    image_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone,
    "primary" boolean,
    cover boolean,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    verified boolean
);


--
-- Name: episode_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE episode_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: episode_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE episode_images_id_seq OWNED BY episode_images.id;


--
-- Name: episode_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE episode_links (
    id integer NOT NULL,
    url text,
    title character varying(255),
    alt_text character varying(255),
    episode_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: episode_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE episode_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: episode_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE episode_links_id_seq OWNED BY episode_links.id;


--
-- Name: episodes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE episodes (
    id integer NOT NULL,
    season integer,
    episode_number integer,
    name character varying(255),
    airdate timestamp without time zone,
    show_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying(255),
    tagline character varying(255),
    verified boolean,
    approved boolean DEFAULT false,
    deleted_at timestamp without time zone,
    flag boolean,
    creator_id integer,
    paid boolean,
    air_length integer,
    fc_completed boolean,
    as_completed boolean
);


--
-- Name: episodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE episodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE episodes_id_seq OWNED BY episodes.id;


--
-- Name: episodes_products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE episodes_products (
    episode_id integer,
    product_id integer
);


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feedbacks (
    id integer NOT NULL,
    email character varying(255),
    content text,
    category character varying(255),
    status character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feedbacks_id_seq OWNED BY feedbacks.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE identities (
    id integer NOT NULL,
    user_id integer,
    provider character varying(255),
    uid character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE identities_id_seq OWNED BY identities.id;


--
-- Name: movie_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE movie_images (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    "primary" boolean,
    movie_id integer,
    verified boolean,
    cover boolean,
    poster boolean
);


--
-- Name: movie_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE movie_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movie_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE movie_images_id_seq OWNED BY movie_images.id;


--
-- Name: movies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE movies (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    flag boolean,
    verified boolean,
    slug text,
    deleted_at timestamp without time zone,
    tagline character varying(255),
    creator_id integer,
    approved boolean,
    completed boolean,
    paid boolean,
    release_date timestamp without time zone,
    air_length integer
);


--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE movies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE movies_id_seq OWNED BY movies.id;


--
-- Name: movies_producers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE movies_producers (
    movie_id integer NOT NULL,
    producer_id integer NOT NULL
);


--
-- Name: networks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE networks (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    creator_id integer,
    approved boolean DEFAULT false,
    verified boolean DEFAULT false
);


--
-- Name: networks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE networks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: networks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE networks_id_seq OWNED BY networks.id;


--
-- Name: option_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE option_images (
    id integer NOT NULL,
    option_id integer,
    url text,
    alt_text text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone
);


--
-- Name: option_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE option_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: option_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE option_images_id_seq OWNED BY option_images.id;


--
-- Name: options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE options (
    id integer NOT NULL,
    text character varying(255),
    value integer,
    quiz_question_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE options_id_seq OWNED BY options.id;


--
-- Name: outfit_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE outfit_images (
    id integer NOT NULL,
    outfit_id integer,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    verified boolean
);


--
-- Name: outfit_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE outfit_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outfit_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE outfit_images_id_seq OWNED BY outfit_images.id;


--
-- Name: outfits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE outfits (
    id integer NOT NULL,
    start_time integer,
    end_time integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    character_id integer,
    change character varying(255),
    verified boolean,
    approved boolean DEFAULT false,
    deleted_at timestamp without time zone,
    flag boolean,
    creator_id integer,
    slug character varying(255),
    featured boolean DEFAULT false,
    contains_exact_match boolean,
    description text DEFAULT 'Outfit Description Unavailable'::text
);


--
-- Name: outfits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE outfits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outfits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE outfits_id_seq OWNED BY outfits.id;


--
-- Name: outfits_products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE outfits_products (
    outfit_id integer,
    product_id integer,
    id integer NOT NULL,
    exact_match boolean
);


--
-- Name: outfits_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE outfits_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outfits_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE outfits_products_id_seq OWNED BY outfits_products.id;


--
-- Name: outfits_scenes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE outfits_scenes (
    outfit_id integer,
    scene_id integer
);


--
-- Name: producers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE producers (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: producers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE producers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: producers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE producers_id_seq OWNED BY producers.id;


--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    gender character varying(255)
);


--
-- Name: product_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_categories_id_seq OWNED BY product_categories.id;


--
-- Name: product_categories_products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_categories_products (
    product_category_id integer,
    product_id integer
);


--
-- Name: product_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_images (
    id integer NOT NULL,
    url character varying(255),
    alt_text character varying(255),
    product_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    verified boolean,
    "primary" boolean
);


--
-- Name: product_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_images_id_seq OWNED BY product_images.id;


--
-- Name: product_ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_ratings (
    id integer NOT NULL,
    user_id integer,
    product_id integer,
    value integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: product_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_ratings_id_seq OWNED BY product_ratings.id;


--
-- Name: product_sets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_sets (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    flag boolean DEFAULT false,
    approved boolean DEFAULT false,
    last_updater_id integer
);


--
-- Name: product_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_sets_id_seq OWNED BY product_sets.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products (
    id integer NOT NULL,
    name character varying(255),
    description text,
    qr_code text,
    character_id integer,
    brand_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying(255),
    verified boolean,
    approved boolean DEFAULT false,
    deleted_at timestamp without time zone,
    flag boolean,
    creator_id integer,
    product_set_id integer,
    episode_count integer,
    character_count integer
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profiles (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: prop_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prop_categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: prop_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prop_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prop_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prop_categories_id_seq OWNED BY prop_categories.id;


--
-- Name: prop_categories_prop_category_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prop_categories_prop_category_groups (
    id integer NOT NULL,
    prop_category_id integer,
    prop_category_group_id integer
);


--
-- Name: prop_categories_prop_category_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prop_categories_prop_category_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prop_categories_prop_category_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prop_categories_prop_category_groups_id_seq OWNED BY prop_categories_prop_category_groups.id;


--
-- Name: prop_categories_props; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prop_categories_props (
    id integer NOT NULL,
    prop_id integer,
    prop_category_id integer
);


--
-- Name: prop_categories_props_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prop_categories_props_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prop_categories_props_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prop_categories_props_id_seq OWNED BY prop_categories_props.id;


--
-- Name: prop_category_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prop_category_groups (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: prop_category_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prop_category_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prop_category_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prop_category_groups_id_seq OWNED BY prop_category_groups.id;


--
-- Name: prop_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prop_images (
    id integer NOT NULL,
    url character varying(255),
    alt_text character varying(255),
    prop_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone
);


--
-- Name: prop_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prop_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prop_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prop_images_id_seq OWNED BY prop_images.id;


--
-- Name: props; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE props (
    id integer NOT NULL,
    name character varying(255),
    description text,
    slug character varying(255),
    brand_id integer,
    flag boolean,
    approved boolean,
    verified boolean,
    creator_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: props_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE props_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: props_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE props_id_seq OWNED BY props.id;


--
-- Name: props_scenes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE props_scenes (
    id integer NOT NULL,
    prop_id integer,
    scene_id integer,
    exact_match boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: props_scenes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE props_scenes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: props_scenes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE props_scenes_id_seq OWNED BY props_scenes.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    title character varying(255),
    description character varying(255),
    text character varying(255),
    answered boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    creator_id integer
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: quiz_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quiz_images (
    id integer NOT NULL,
    quiz_id integer,
    url text,
    alt_text text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone
);


--
-- Name: quiz_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quiz_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quiz_images_id_seq OWNED BY quiz_images.id;


--
-- Name: quiz_questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quiz_questions (
    id integer NOT NULL,
    text character varying(255),
    quiz_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: quiz_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quiz_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quiz_questions_id_seq OWNED BY quiz_questions.id;


--
-- Name: quiz_takes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quiz_takes (
    id integer NOT NULL,
    user_id integer,
    quiz_id integer,
    result_id integer,
    quiz_question_ids integer[] DEFAULT '{}'::integer[],
    answer_ids integer[] DEFAULT '{}'::integer[],
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: quiz_takes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quiz_takes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_takes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quiz_takes_id_seq OWNED BY quiz_takes.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quizzes (
    id integer NOT NULL,
    title character varying(255),
    creator_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    approved boolean DEFAULT false,
    verified boolean DEFAULT false,
    flag boolean DEFAULT false,
    paid boolean DEFAULT false,
    result_header character varying(255)
);


--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quizzes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quizzes_id_seq OWNED BY quizzes.id;


--
-- Name: result_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE result_images (
    id integer NOT NULL,
    result_id integer,
    url text,
    alt_text text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone
);


--
-- Name: result_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE result_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: result_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE result_images_id_seq OWNED BY result_images.id;


--
-- Name: results; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE results (
    id integer NOT NULL,
    url character varying(255),
    text character varying(255),
    title character varying(255),
    quiz_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    value integer
);


--
-- Name: results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE results_id_seq OWNED BY results.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reviews (
    id integer NOT NULL,
    reviewer_id integer,
    review_item_id integer,
    review_item_type character varying(255)
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reviews_id_seq OWNED BY reviews.id;


--
-- Name: scene_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE scene_images (
    id integer NOT NULL,
    scene_id integer,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    alt_text character varying(255),
    "primary" boolean,
    cover boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    verified boolean
);


--
-- Name: scene_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scene_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scene_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE scene_images_id_seq OWNED BY scene_images.id;


--
-- Name: scenes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE scenes (
    id integer NOT NULL,
    start_time integer,
    end_time integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    episode_id integer,
    deleted_at timestamp without time zone,
    movie_id integer,
    scene_number integer,
    intro boolean,
    verified boolean,
    flag boolean DEFAULT false,
    approved boolean DEFAULT false,
    creator_id integer,
    slug character varying(255)
);


--
-- Name: scenes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scenes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scenes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE scenes_id_seq OWNED BY scenes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: shows; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shows (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying(255),
    deleted_at timestamp without time zone,
    approved boolean,
    flag boolean,
    creator_id integer,
    network_id integer,
    verified boolean,
    featured boolean
);


--
-- Name: stores; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stores (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying(255)
);


--
-- Name: searches; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW searches AS
        (        (        (        (        (         SELECT brands.id AS searchable_id,
                                                    'Brand'::text AS searchable_type,
                                                    brands.name AS term
                                                   FROM brands
                                        UNION
                                                 SELECT product_categories.id AS searchable_id,
                                                    'ProductCategory'::text AS searchable_type,
                                                    product_categories.name AS term
                                                   FROM product_categories)
                                UNION
                                         SELECT products.id AS searchable_id,
                                            'Product'::text AS searchable_type,
                                            products.name AS term
                                           FROM products)
                        UNION
                                 SELECT products.id AS searchable_id,
                                    'Product'::text AS searchable_type,
                                    products.description AS term
                                   FROM products)
                UNION
                         SELECT shows.id AS searchable_id,
                            'Show'::text AS searchable_type,
                            shows.name AS term
                           FROM shows)
        UNION
                 SELECT stores.id AS searchable_id,
                    'Store'::text AS searchable_type,
                    stores.name AS term
                   FROM stores)
UNION
         SELECT episodes.id AS searchable_id,
            'Episode'::text AS searchable_type,
            episodes.slug AS term
           FROM episodes;


--
-- Name: show_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE show_images (
    id integer NOT NULL,
    alt_text character varying(255),
    show_id integer,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    verified boolean,
    cover boolean,
    poster boolean,
    landing boolean
);


--
-- Name: show_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE show_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: show_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE show_images_id_seq OWNED BY show_images.id;


--
-- Name: shows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shows_id_seq OWNED BY shows.id;


--
-- Name: sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sources (
    id integer NOT NULL,
    url text,
    price_cents integer DEFAULT 0 NOT NULL,
    price_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL,
    status character varying(255),
    store_id integer,
    product_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    in_stock boolean,
    available boolean DEFAULT true,
    link_last_checked timestamp without time zone DEFAULT '2013-08-01 16:29:12.835695'::timestamp without time zone,
    sourceable_id integer,
    sourceable_type character varying(255)
);


--
-- Name: sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sources_id_seq OWNED BY sources.id;


--
-- Name: stars; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stars (
    id integer NOT NULL,
    user_id integer,
    starable_id integer,
    starable_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: stars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stars_id_seq OWNED BY stars.id;


--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stores_id_seq OWNED BY stores.id;


--
-- Name: table_prop_categories_props; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE table_prop_categories_props (
    id integer NOT NULL,
    prop_id integer,
    prop_category_id integer
);


--
-- Name: table_prop_categories_props_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE table_prop_categories_props_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: table_prop_categories_props_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE table_prop_categories_props_id_seq OWNED BY table_prop_categories_props.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255),
    password_digest character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    admin boolean,
    auth_token character varying(255),
    role character varying(255) DEFAULT 'Basic'::character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying(255) NOT NULL,
    item_id integer NOT NULL,
    event character varying(255) NOT NULL,
    whodunnit character varying(255),
    object text,
    created_at timestamp without time zone,
    object_changes text
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_clients ALTER COLUMN id SET DEFAULT nextval('api_clients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY brands ALTER COLUMN id SET DEFAULT nextval('brands_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY category_groups ALTER COLUMN id SET DEFAULT nextval('category_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY character_images ALTER COLUMN id SET DEFAULT nextval('character_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY characters ALTER COLUMN id SET DEFAULT nextval('characters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY colors ALTER COLUMN id SET DEFAULT nextval('colors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comment_flags ALTER COLUMN id SET DEFAULT nextval('comment_flags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY directors ALTER COLUMN id SET DEFAULT nextval('directors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY durations ALTER COLUMN id SET DEFAULT nextval('durations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY episode_images ALTER COLUMN id SET DEFAULT nextval('episode_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY episode_links ALTER COLUMN id SET DEFAULT nextval('episode_links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY episodes ALTER COLUMN id SET DEFAULT nextval('episodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedbacks ALTER COLUMN id SET DEFAULT nextval('feedbacks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities ALTER COLUMN id SET DEFAULT nextval('identities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY movie_images ALTER COLUMN id SET DEFAULT nextval('movie_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY movies ALTER COLUMN id SET DEFAULT nextval('movies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY networks ALTER COLUMN id SET DEFAULT nextval('networks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY option_images ALTER COLUMN id SET DEFAULT nextval('option_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY options ALTER COLUMN id SET DEFAULT nextval('options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY outfit_images ALTER COLUMN id SET DEFAULT nextval('outfit_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY outfits ALTER COLUMN id SET DEFAULT nextval('outfits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY outfits_products ALTER COLUMN id SET DEFAULT nextval('outfits_products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY producers ALTER COLUMN id SET DEFAULT nextval('producers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_categories ALTER COLUMN id SET DEFAULT nextval('product_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_images ALTER COLUMN id SET DEFAULT nextval('product_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_ratings ALTER COLUMN id SET DEFAULT nextval('product_ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_sets ALTER COLUMN id SET DEFAULT nextval('product_sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prop_categories ALTER COLUMN id SET DEFAULT nextval('prop_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prop_categories_prop_category_groups ALTER COLUMN id SET DEFAULT nextval('prop_categories_prop_category_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prop_categories_props ALTER COLUMN id SET DEFAULT nextval('prop_categories_props_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prop_category_groups ALTER COLUMN id SET DEFAULT nextval('prop_category_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prop_images ALTER COLUMN id SET DEFAULT nextval('prop_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY props ALTER COLUMN id SET DEFAULT nextval('props_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY props_scenes ALTER COLUMN id SET DEFAULT nextval('props_scenes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quiz_images ALTER COLUMN id SET DEFAULT nextval('quiz_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quiz_questions ALTER COLUMN id SET DEFAULT nextval('quiz_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quiz_takes ALTER COLUMN id SET DEFAULT nextval('quiz_takes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quizzes ALTER COLUMN id SET DEFAULT nextval('quizzes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY result_images ALTER COLUMN id SET DEFAULT nextval('result_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY results ALTER COLUMN id SET DEFAULT nextval('results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reviews ALTER COLUMN id SET DEFAULT nextval('reviews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY scene_images ALTER COLUMN id SET DEFAULT nextval('scene_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY scenes ALTER COLUMN id SET DEFAULT nextval('scenes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY show_images ALTER COLUMN id SET DEFAULT nextval('show_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shows ALTER COLUMN id SET DEFAULT nextval('shows_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sources ALTER COLUMN id SET DEFAULT nextval('sources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stars ALTER COLUMN id SET DEFAULT nextval('stars_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stores ALTER COLUMN id SET DEFAULT nextval('stores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY table_prop_categories_props ALTER COLUMN id SET DEFAULT nextval('table_prop_categories_props_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: api_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY api_clients
    ADD CONSTRAINT api_clients_pkey PRIMARY KEY (id);


--
-- Name: brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: category_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY category_groups
    ADD CONSTRAINT category_groups_pkey PRIMARY KEY (id);


--
-- Name: character_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY character_images
    ADD CONSTRAINT character_images_pkey PRIMARY KEY (id);


--
-- Name: characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: colors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY colors
    ADD CONSTRAINT colors_pkey PRIMARY KEY (id);


--
-- Name: comment_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comment_flags
    ADD CONSTRAINT comment_flags_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: directors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY directors
    ADD CONSTRAINT directors_pkey PRIMARY KEY (id);


--
-- Name: durations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY durations
    ADD CONSTRAINT durations_pkey PRIMARY KEY (id);


--
-- Name: episode_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY episode_images
    ADD CONSTRAINT episode_images_pkey PRIMARY KEY (id);


--
-- Name: episode_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY episode_links
    ADD CONSTRAINT episode_links_pkey PRIMARY KEY (id);


--
-- Name: episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY episodes
    ADD CONSTRAINT episodes_pkey PRIMARY KEY (id);


--
-- Name: feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: movie_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY movie_images
    ADD CONSTRAINT movie_images_pkey PRIMARY KEY (id);


--
-- Name: movies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: networks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY networks
    ADD CONSTRAINT networks_pkey PRIMARY KEY (id);


--
-- Name: option_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY option_images
    ADD CONSTRAINT option_images_pkey PRIMARY KEY (id);


--
-- Name: options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- Name: outfit_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outfit_images
    ADD CONSTRAINT outfit_images_pkey PRIMARY KEY (id);


--
-- Name: outfits_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outfits_products
    ADD CONSTRAINT outfits_products_pkey PRIMARY KEY (id);


--
-- Name: producers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY producers
    ADD CONSTRAINT producers_pkey PRIMARY KEY (id);


--
-- Name: product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- Name: product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (id);


--
-- Name: product_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_ratings
    ADD CONSTRAINT product_ratings_pkey PRIMARY KEY (id);


--
-- Name: product_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_sets
    ADD CONSTRAINT product_sets_pkey PRIMARY KEY (id);


--
-- Name: product_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT product_sources_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: prop_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prop_categories
    ADD CONSTRAINT prop_categories_pkey PRIMARY KEY (id);


--
-- Name: prop_categories_prop_category_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prop_categories_prop_category_groups
    ADD CONSTRAINT prop_categories_prop_category_groups_pkey PRIMARY KEY (id);


--
-- Name: prop_categories_props_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prop_categories_props
    ADD CONSTRAINT prop_categories_props_pkey PRIMARY KEY (id);


--
-- Name: prop_category_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prop_category_groups
    ADD CONSTRAINT prop_category_groups_pkey PRIMARY KEY (id);


--
-- Name: prop_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prop_images
    ADD CONSTRAINT prop_images_pkey PRIMARY KEY (id);


--
-- Name: props_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY props
    ADD CONSTRAINT props_pkey PRIMARY KEY (id);


--
-- Name: props_scenes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY props_scenes
    ADD CONSTRAINT props_scenes_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quiz_images
    ADD CONSTRAINT quiz_images_pkey PRIMARY KEY (id);


--
-- Name: quiz_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quiz_questions
    ADD CONSTRAINT quiz_questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_takes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quiz_takes
    ADD CONSTRAINT quiz_takes_pkey PRIMARY KEY (id);


--
-- Name: quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: result_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY result_images
    ADD CONSTRAINT result_images_pkey PRIMARY KEY (id);


--
-- Name: results_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: scene_appearances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outfits
    ADD CONSTRAINT scene_appearances_pkey PRIMARY KEY (id);


--
-- Name: scene_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY scene_images
    ADD CONSTRAINT scene_images_pkey PRIMARY KEY (id);


--
-- Name: scenes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY scenes
    ADD CONSTRAINT scenes_pkey PRIMARY KEY (id);


--
-- Name: show_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY show_images
    ADD CONSTRAINT show_images_pkey PRIMARY KEY (id);


--
-- Name: shows_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shows
    ADD CONSTRAINT shows_pkey PRIMARY KEY (id);


--
-- Name: stars_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stars
    ADD CONSTRAINT stars_pkey PRIMARY KEY (id);


--
-- Name: stores_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: table_prop_categories_props_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY table_prop_categories_props
    ADD CONSTRAINT table_prop_categories_props_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_brands_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_brands_on_name ON brands USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: index_brands_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_brands_on_slug ON brands USING btree (slug);


--
-- Name: index_category_groups_product_categories_on_category_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_category_groups_product_categories_on_category_group_id ON category_groups_product_categories USING btree (category_group_id);


--
-- Name: index_category_groups_product_categories_on_product_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_category_groups_product_categories_on_product_category_id ON category_groups_product_categories USING btree (product_category_id);


--
-- Name: index_character_images_on_character_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_character_images_on_character_id ON character_images USING btree (character_id);


--
-- Name: index_characters_on_movie_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_characters_on_movie_id ON characters USING btree (movie_id);


--
-- Name: index_characters_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_characters_on_name ON characters USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: index_characters_on_show_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_characters_on_show_id ON characters USING btree (show_id);


--
-- Name: index_characters_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_characters_on_slug ON characters USING btree (slug);


--
-- Name: index_colors_products_on_color_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_colors_products_on_color_id ON colors_products USING btree (color_id);


--
-- Name: index_colors_products_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_colors_products_on_product_id ON colors_products USING btree (product_id);


--
-- Name: index_comment_flags_on_comment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comment_flags_on_comment_id ON comment_flags USING btree (comment_id);


--
-- Name: index_comment_flags_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comment_flags_on_user_id ON comment_flags USING btree (user_id);


--
-- Name: index_comments_on_commentable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_id ON comments USING btree (commentable_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_durations_on_scene_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_durations_on_scene_id ON durations USING btree (scene_id);


--
-- Name: index_episode_images_on_episode_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_episode_images_on_episode_id ON episode_images USING btree (episode_id);


--
-- Name: index_episode_links_on_episode_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_episode_links_on_episode_id ON episode_links USING btree (episode_id);


--
-- Name: index_episodes_on_show_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_episodes_on_show_id ON episodes USING btree (show_id);


--
-- Name: index_episodes_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_episodes_on_slug ON episodes USING btree (slug);


--
-- Name: index_episodes_products_on_episode_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_episodes_products_on_episode_id ON episodes_products USING btree (episode_id);


--
-- Name: index_episodes_products_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_episodes_products_on_product_id ON episodes_products USING btree (product_id);


--
-- Name: index_identities_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_identities_on_user_id ON identities USING btree (user_id);


--
-- Name: index_movie_images_on_movie_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_movie_images_on_movie_id ON movie_images USING btree (movie_id);


--
-- Name: index_option_images_on_option_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_option_images_on_option_id ON option_images USING btree (option_id);


--
-- Name: index_options_on_quiz_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_options_on_quiz_question_id ON options USING btree (quiz_question_id);


--
-- Name: index_outfit_images_on_outfit_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_outfit_images_on_outfit_id ON outfit_images USING btree (outfit_id);


--
-- Name: index_outfits_on_character_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_outfits_on_character_id ON outfits USING btree (character_id);


--
-- Name: index_outfits_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_outfits_on_slug ON outfits USING btree (slug);


--
-- Name: index_outfits_products_on_outfit_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_outfits_products_on_outfit_id ON outfits_products USING btree (outfit_id);


--
-- Name: index_outfits_products_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_outfits_products_on_product_id ON outfits_products USING btree (product_id);


--
-- Name: index_outfits_scenes_on_outfit_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_outfits_scenes_on_outfit_id ON outfits_scenes USING btree (outfit_id);


--
-- Name: index_outfits_scenes_on_scene_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_outfits_scenes_on_scene_id ON outfits_scenes USING btree (scene_id);


--
-- Name: index_product_categories_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_categories_on_name ON product_categories USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: index_product_categories_products_on_product_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_categories_products_on_product_category_id ON product_categories_products USING btree (product_category_id);


--
-- Name: index_product_categories_products_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_categories_products_on_product_id ON product_categories_products USING btree (product_id);


--
-- Name: index_product_images_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_images_on_product_id ON product_images USING btree (product_id);


--
-- Name: index_product_ratings_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_ratings_on_product_id ON product_ratings USING btree (product_id);


--
-- Name: index_product_ratings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_ratings_on_user_id ON product_ratings USING btree (user_id);


--
-- Name: index_product_sets_on_last_updater_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_sets_on_last_updater_id ON product_sets USING btree (last_updater_id);


--
-- Name: index_products_on_brand_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_on_brand_id ON products USING btree (brand_id);


--
-- Name: index_products_on_character_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_on_character_id ON products USING btree (character_id);


--
-- Name: index_products_on_description; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_on_description ON products USING gin (to_tsvector('english'::regconfig, description));


--
-- Name: index_products_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_on_name ON products USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: index_products_on_product_set_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_on_product_set_id ON products USING btree (product_set_id);


--
-- Name: index_products_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_on_slug ON products USING btree (slug);


--
-- Name: index_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profiles_on_user_id ON profiles USING btree (user_id);


--
-- Name: index_prop_categories_prop_category_groups_on_prop_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_prop_categories_prop_category_groups_on_prop_category_id ON prop_categories_prop_category_groups USING btree (prop_category_id);


--
-- Name: index_prop_categories_props_on_prop_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_prop_categories_props_on_prop_category_id ON prop_categories_props USING btree (prop_category_id);


--
-- Name: index_prop_categories_props_on_prop_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_prop_categories_props_on_prop_id ON prop_categories_props USING btree (prop_id);


--
-- Name: index_prop_images_on_prop_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_prop_images_on_prop_id ON prop_images USING btree (prop_id);


--
-- Name: index_props_on_brand_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_props_on_brand_id ON props USING btree (brand_id);


--
-- Name: index_props_on_creator_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_props_on_creator_id ON props USING btree (creator_id);


--
-- Name: index_props_scenes_on_prop_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_props_scenes_on_prop_id ON props_scenes USING btree (prop_id);


--
-- Name: index_props_scenes_on_scene_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_props_scenes_on_scene_id ON props_scenes USING btree (scene_id);


--
-- Name: index_quiz_images_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quiz_images_on_quiz_id ON quiz_images USING btree (quiz_id);


--
-- Name: index_quiz_questions_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quiz_questions_on_quiz_id ON quiz_questions USING btree (quiz_id);


--
-- Name: index_quiz_takes_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quiz_takes_on_quiz_id ON quiz_takes USING btree (quiz_id);


--
-- Name: index_quiz_takes_on_result_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quiz_takes_on_result_id ON quiz_takes USING btree (result_id);


--
-- Name: index_quiz_takes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quiz_takes_on_user_id ON quiz_takes USING btree (user_id);


--
-- Name: index_result_images_on_result_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_result_images_on_result_id ON result_images USING btree (result_id);


--
-- Name: index_results_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_results_on_quiz_id ON results USING btree (quiz_id);


--
-- Name: index_scene_images_on_scene_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_scene_images_on_scene_id ON scene_images USING btree (scene_id);


--
-- Name: index_scenes_on_movie_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_scenes_on_movie_id ON scenes USING btree (movie_id);


--
-- Name: index_scenes_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_scenes_on_slug ON scenes USING btree (slug);


--
-- Name: index_show_images_on_show_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_show_images_on_show_id ON show_images USING btree (show_id);


--
-- Name: index_shows_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shows_on_name ON shows USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: index_shows_on_network_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shows_on_network_id ON shows USING btree (network_id);


--
-- Name: index_shows_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shows_on_slug ON shows USING btree (slug);


--
-- Name: index_sources_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sources_on_product_id ON sources USING btree (product_id);


--
-- Name: index_sources_on_store_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sources_on_store_id ON sources USING btree (store_id);


--
-- Name: index_stores_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stores_on_name ON stores USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: index_stores_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stores_on_slug ON stores USING btree (slug);


--
-- Name: index_table_prop_categories_props_on_prop_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_table_prop_categories_props_on_prop_category_id ON table_prop_categories_props USING btree (prop_category_id);


--
-- Name: index_table_prop_categories_props_on_prop_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_table_prop_categories_props_on_prop_id ON table_prop_categories_props USING btree (prop_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: pc_pcg_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX pc_pcg_index ON prop_categories_prop_category_groups USING btree (prop_category_id, prop_category_group_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20131002211354');

INSERT INTO schema_migrations (version) VALUES ('20131002222403');

INSERT INTO schema_migrations (version) VALUES ('20131002232323');

INSERT INTO schema_migrations (version) VALUES ('20131002232326');

INSERT INTO schema_migrations (version) VALUES ('20131002232329');

INSERT INTO schema_migrations (version) VALUES ('20131002232332');

INSERT INTO schema_migrations (version) VALUES ('20131002232338');

INSERT INTO schema_migrations (version) VALUES ('20131002232341');

INSERT INTO schema_migrations (version) VALUES ('20131002232346');

INSERT INTO schema_migrations (version) VALUES ('20131002232347');

INSERT INTO schema_migrations (version) VALUES ('20131002232349');

INSERT INTO schema_migrations (version) VALUES ('20131002232350');

INSERT INTO schema_migrations (version) VALUES ('20131002232357');

INSERT INTO schema_migrations (version) VALUES ('20131002232400');

INSERT INTO schema_migrations (version) VALUES ('20131002233911');

INSERT INTO schema_migrations (version) VALUES ('20131002233912');

INSERT INTO schema_migrations (version) VALUES ('20131009140519');

INSERT INTO schema_migrations (version) VALUES ('20131021174519');

INSERT INTO schema_migrations (version) VALUES ('20131021174655');

INSERT INTO schema_migrations (version) VALUES ('20131021192153');

INSERT INTO schema_migrations (version) VALUES ('20131024001653');

INSERT INTO schema_migrations (version) VALUES ('20131024001810');

INSERT INTO schema_migrations (version) VALUES ('20131024001819');

INSERT INTO schema_migrations (version) VALUES ('20131024001830');

INSERT INTO schema_migrations (version) VALUES ('20131024001857');

INSERT INTO schema_migrations (version) VALUES ('20131024001932');

INSERT INTO schema_migrations (version) VALUES ('20131024010632');

INSERT INTO schema_migrations (version) VALUES ('20131024010656');

INSERT INTO schema_migrations (version) VALUES ('20131024023348');

INSERT INTO schema_migrations (version) VALUES ('20131024024115');

INSERT INTO schema_migrations (version) VALUES ('20131024024403');

INSERT INTO schema_migrations (version) VALUES ('20131026215939');

INSERT INTO schema_migrations (version) VALUES ('20131028001518');

INSERT INTO schema_migrations (version) VALUES ('20131029054822');

INSERT INTO schema_migrations (version) VALUES ('20131029055010');

INSERT INTO schema_migrations (version) VALUES ('20131105221332');

INSERT INTO schema_migrations (version) VALUES ('20131105224959');

INSERT INTO schema_migrations (version) VALUES ('20131105232126');

INSERT INTO schema_migrations (version) VALUES ('20131105232150');

INSERT INTO schema_migrations (version) VALUES ('20131107220935');

INSERT INTO schema_migrations (version) VALUES ('20131109172633');

INSERT INTO schema_migrations (version) VALUES ('20131109173455');

INSERT INTO schema_migrations (version) VALUES ('20131109173932');

INSERT INTO schema_migrations (version) VALUES ('20131109174045');

INSERT INTO schema_migrations (version) VALUES ('20131109174252');

INSERT INTO schema_migrations (version) VALUES ('20131109174531');

INSERT INTO schema_migrations (version) VALUES ('20131109174551');

INSERT INTO schema_migrations (version) VALUES ('20131109181935');

INSERT INTO schema_migrations (version) VALUES ('20131109190508');

INSERT INTO schema_migrations (version) VALUES ('20131109190635');

INSERT INTO schema_migrations (version) VALUES ('20131109192038');

INSERT INTO schema_migrations (version) VALUES ('20131109201239');

INSERT INTO schema_migrations (version) VALUES ('20131109224822');

INSERT INTO schema_migrations (version) VALUES ('20131110001722');

INSERT INTO schema_migrations (version) VALUES ('20131110005503');

INSERT INTO schema_migrations (version) VALUES ('20131110010337');

INSERT INTO schema_migrations (version) VALUES ('20131114170652');

INSERT INTO schema_migrations (version) VALUES ('20131115030614');

INSERT INTO schema_migrations (version) VALUES ('20131115201251');

INSERT INTO schema_migrations (version) VALUES ('20131117201917');

INSERT INTO schema_migrations (version) VALUES ('20131118222517');

INSERT INTO schema_migrations (version) VALUES ('20131121061203');

INSERT INTO schema_migrations (version) VALUES ('20131121070100');

INSERT INTO schema_migrations (version) VALUES ('20131121140146');

INSERT INTO schema_migrations (version) VALUES ('20131122213143');

INSERT INTO schema_migrations (version) VALUES ('20131124231519');

INSERT INTO schema_migrations (version) VALUES ('20131125192038');

INSERT INTO schema_migrations (version) VALUES ('20131210185309');

INSERT INTO schema_migrations (version) VALUES ('20131210185348');

INSERT INTO schema_migrations (version) VALUES ('20131210185407');

INSERT INTO schema_migrations (version) VALUES ('20131210185419');

INSERT INTO schema_migrations (version) VALUES ('20131210185434');

INSERT INTO schema_migrations (version) VALUES ('20131212140857');

INSERT INTO schema_migrations (version) VALUES ('20131214014728');

INSERT INTO schema_migrations (version) VALUES ('20131215024633');

INSERT INTO schema_migrations (version) VALUES ('20131215201520');

INSERT INTO schema_migrations (version) VALUES ('20140102192505');

INSERT INTO schema_migrations (version) VALUES ('20140102192609');

INSERT INTO schema_migrations (version) VALUES ('20140117203403');

INSERT INTO schema_migrations (version) VALUES ('20140119180742');

INSERT INTO schema_migrations (version) VALUES ('20140119180759');

INSERT INTO schema_migrations (version) VALUES ('20140119181822');

INSERT INTO schema_migrations (version) VALUES ('20140119182043');

INSERT INTO schema_migrations (version) VALUES ('20140119182125');

INSERT INTO schema_migrations (version) VALUES ('20140119182342');

INSERT INTO schema_migrations (version) VALUES ('20140119182453');

INSERT INTO schema_migrations (version) VALUES ('20140119183039');

INSERT INTO schema_migrations (version) VALUES ('20140119183708');

INSERT INTO schema_migrations (version) VALUES ('20140119184110');

INSERT INTO schema_migrations (version) VALUES ('20140119184329');

INSERT INTO schema_migrations (version) VALUES ('20140119184709');

INSERT INTO schema_migrations (version) VALUES ('20140119185104');

INSERT INTO schema_migrations (version) VALUES ('20140119185920');

INSERT INTO schema_migrations (version) VALUES ('20140119191531');

INSERT INTO schema_migrations (version) VALUES ('20140119191946');

INSERT INTO schema_migrations (version) VALUES ('20140119200414');

INSERT INTO schema_migrations (version) VALUES ('20140122073431');

INSERT INTO schema_migrations (version) VALUES ('20140122173430');

INSERT INTO schema_migrations (version) VALUES ('20140122173501');

INSERT INTO schema_migrations (version) VALUES ('20140122205317');

INSERT INTO schema_migrations (version) VALUES ('20140123143731');

INSERT INTO schema_migrations (version) VALUES ('20140123143952');

INSERT INTO schema_migrations (version) VALUES ('20140123144503');

INSERT INTO schema_migrations (version) VALUES ('20140123144554');

INSERT INTO schema_migrations (version) VALUES ('20140124170638');

INSERT INTO schema_migrations (version) VALUES ('20140124170940');

INSERT INTO schema_migrations (version) VALUES ('20140201191837');

INSERT INTO schema_migrations (version) VALUES ('20140203172546');

INSERT INTO schema_migrations (version) VALUES ('20140203192152');

INSERT INTO schema_migrations (version) VALUES ('20140204002846');

INSERT INTO schema_migrations (version) VALUES ('20140204003058');

INSERT INTO schema_migrations (version) VALUES ('20140204011315');

INSERT INTO schema_migrations (version) VALUES ('20140204013052');

INSERT INTO schema_migrations (version) VALUES ('20140204141655');

INSERT INTO schema_migrations (version) VALUES ('20140204173615');

INSERT INTO schema_migrations (version) VALUES ('20140207191544');

INSERT INTO schema_migrations (version) VALUES ('20140207191848');

INSERT INTO schema_migrations (version) VALUES ('20140207192339');

INSERT INTO schema_migrations (version) VALUES ('20140209220136');

INSERT INTO schema_migrations (version) VALUES ('20140210185508');

INSERT INTO schema_migrations (version) VALUES ('20140210185544');

INSERT INTO schema_migrations (version) VALUES ('20140212225051');

INSERT INTO schema_migrations (version) VALUES ('20140214183018');

INSERT INTO schema_migrations (version) VALUES ('20140218165543');

INSERT INTO schema_migrations (version) VALUES ('20140218183206');

INSERT INTO schema_migrations (version) VALUES ('20140220151448');

INSERT INTO schema_migrations (version) VALUES ('20140221004502');

INSERT INTO schema_migrations (version) VALUES ('20140221004852');

INSERT INTO schema_migrations (version) VALUES ('20140223031029');

INSERT INTO schema_migrations (version) VALUES ('20140223031054');

INSERT INTO schema_migrations (version) VALUES ('20140224205030');

INSERT INTO schema_migrations (version) VALUES ('20140228021431');

INSERT INTO schema_migrations (version) VALUES ('20140330200632');

INSERT INTO schema_migrations (version) VALUES ('20140430190651');

INSERT INTO schema_migrations (version) VALUES ('20140501164810');

INSERT INTO schema_migrations (version) VALUES ('20140606153701');

INSERT INTO schema_migrations (version) VALUES ('20140620023922');

INSERT INTO schema_migrations (version) VALUES ('20140620073431');

INSERT INTO schema_migrations (version) VALUES ('20140620082424');

INSERT INTO schema_migrations (version) VALUES ('20140620082644');

INSERT INTO schema_migrations (version) VALUES ('20140724171740');

INSERT INTO schema_migrations (version) VALUES ('20140724172258');

INSERT INTO schema_migrations (version) VALUES ('20140724172345');

INSERT INTO schema_migrations (version) VALUES ('20140724172435');

INSERT INTO schema_migrations (version) VALUES ('20140724180459');

INSERT INTO schema_migrations (version) VALUES ('20140728182643');

INSERT INTO schema_migrations (version) VALUES ('20140729233511');

INSERT INTO schema_migrations (version) VALUES ('20140801161952');

INSERT INTO schema_migrations (version) VALUES ('20140801162736');

INSERT INTO schema_migrations (version) VALUES ('20140801235458');

INSERT INTO schema_migrations (version) VALUES ('20140801235606');

INSERT INTO schema_migrations (version) VALUES ('20140801235635');

INSERT INTO schema_migrations (version) VALUES ('20140801235718');

INSERT INTO schema_migrations (version) VALUES ('20140801235827');

INSERT INTO schema_migrations (version) VALUES ('20140802001419');

INSERT INTO schema_migrations (version) VALUES ('20140805042419');

INSERT INTO schema_migrations (version) VALUES ('20140805043543');

INSERT INTO schema_migrations (version) VALUES ('20140805043758');

INSERT INTO schema_migrations (version) VALUES ('20140805052300');

INSERT INTO schema_migrations (version) VALUES ('20140806181853');

INSERT INTO schema_migrations (version) VALUES ('20140807232439');

INSERT INTO schema_migrations (version) VALUES ('20140808032414');

INSERT INTO schema_migrations (version) VALUES ('20140808032850');

INSERT INTO schema_migrations (version) VALUES ('20140808032903');

INSERT INTO schema_migrations (version) VALUES ('20140808044043');

INSERT INTO schema_migrations (version) VALUES ('20140808054451');

INSERT INTO schema_migrations (version) VALUES ('20140808171026');

INSERT INTO schema_migrations (version) VALUES ('20140808171143');

INSERT INTO schema_migrations (version) VALUES ('20140808171232');

INSERT INTO schema_migrations (version) VALUES ('20140808171324');

INSERT INTO schema_migrations (version) VALUES ('20140808171443');

INSERT INTO schema_migrations (version) VALUES ('20140808220033');

INSERT INTO schema_migrations (version) VALUES ('20140808222938');

