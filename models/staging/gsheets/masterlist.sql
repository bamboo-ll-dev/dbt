{{ config(materialized='table') }}

SELECT * FROM `leslunes-raw.products.masterlist` WHERE product_name IS NOT NULL;

