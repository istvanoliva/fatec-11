CREATE TABLE tb_log (
    id SERIAL PRIMARY KEY,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nome_procedimento VARCHAR(200)
);

CREATE OR REPLACE PROCEDURE sp_cadastrar_cliente (IN nome VARCHAR(200), IN codigo INT DEFAULT NULL)
LANGUAGE plpgsql
AS $$
BEGIN
    IF codigo IS NULL THEN
        INSERT INTO tb_cliente (nome) VALUES (nome);
    ELSE
        INSERT INTO tb_cliente (codigo, nome) VALUES (codigo, nome);
    END IF;

    -- Inserir registro no log
    INSERT INTO tb_log (nome_procedimento) VALUES ('sp_cadastrar_cliente');
END;
$$;
