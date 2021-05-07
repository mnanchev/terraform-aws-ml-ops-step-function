FROM public.ecr.aws/lambda/python:3.8
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --upgrade awswrangler && \
    pip install --no-cache-dir --upgrade oauth2client && \
    pip install --no-cache-dir --upgrade gspread
COPY app.py   ./
CMD ["app.handler"]