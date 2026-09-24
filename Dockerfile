# Dockerfile del repositorio base.
# Contiene cinco malas practicas deliberadas. Cada una lleva su numero en la
# linea anterior. Corregirlas es el bloque A1 de la guia del laboratorio.

# defecto 1
FROM public.ecr.aws/lambda/nodejs:20 AS build

WORKDIR ${LAMBDA_TASK_ROOT}

# defecto 2
COPY package.json package-lock.json ./

RUN npm ci

COPY src ./src

# defecto 3
RUN npm run build

# defecto 4
FROM public.ecr.aws/lambda/nodejs:20 AS runtime

# defecto 5
COPY --from=build ${LAMBDA_TASK_ROOT}/dist/handler.js ${LAMBDA_TASK_ROOT}/handler.js

CMD ["handler.handler"]
