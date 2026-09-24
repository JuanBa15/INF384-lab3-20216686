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

### NO TOCAR DE ACA EN ADELANTE, CONSIDEREN QUE EL WORKDIR DEBE SER /build
RUN npx esbuild src/handler.js \
      --bundle --platform=node --target=node20 \
      --outfile=dist/handler.js

# Etapa final: recibe unicamente el artefacto empaquetado.
# El arbol de node_modules se queda en la etapa anterior.
FROM public.ecr.aws/lambda/nodejs:20 AS runtime
COPY --from=build /build/dist/handler.js ${LAMBDA_TASK_ROOT}/
CMD ["handler.handler"]
