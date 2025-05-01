# Guia de Setup do Projeto

## 1. Requisitos Mínimos

Antes de começar, certifique-se de ter instalados em sua máquina:

- **Docker**
- **Docker Compose** (versão plugin `docker compose`)
- **Git**

---

## 2. Build e Inicialização dos Containers

1. No diretório raiz do projeto, execute o build sem cache:

    ```bash
    docker compose build --no-cache
    ```

2. Suba os containers em modo detached:

    ```bash
    docker compose up -d
    ```

---

## 3. Preparação do Banco de Dados

Execute, em um terminal separado ou usando múltiplos terminais:

```bash
# cria, migra e popula o banco de dados de development
docker compose run app rails db:create db:migrate db:seed
```

> Caso precise recriar do zero, adicione `db:drop` antes de `db:create`.

---

## 4. Acesso à Aplicação

Com os serviços em execução, a API estará disponível em:

```
http://localhost:3000
```

Para testar um endpoint, por exemplo:

```bash
curl http://localhost:3000/api/v1/directories
```

---

## 5. Documentação Interativa (Rswag)

Para facilitar o consumo da API, geramos uma interface Swagger. Com o servidor rodando, acesse:

```
http://localhost:3000/api-docs
```

---

## 6. Suíte de Testes

Para rodar todos os testes RSpec:

```bash
docker compose run app bundle exec rspec
```

---

## 7. Qualidade de Código

### RuboCop

Verificação de estilo e convenções:
```bash
docker compose run app bundle exec rubocop
```

### Brakeman

Análise estática de segurança:
```bash
docker compose run app bundle exec brakeman
```

[← Voltar ao README](../README.md)