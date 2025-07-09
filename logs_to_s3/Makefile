# Makefile para compressão e upload de logs para S3

BUCKET = mikeniner-logs-2025
INPUT_DIR = ../input_logs

upload:
	@echo "[MAKE] Running upload for all files in $(INPUT_DIR) to bucket $(BUCKET)"
	./aws_logs_to_s3.sh $(INPUT_DIR) $(BUCKET)

log:
	@cat logs/upload.log

clean:
	@rm -f /tmp/*.tar.gz
	@echo "[MAKE] Temporary archives removed"

help:
	@echo "Targets disponíveis:"
	@echo "  make upload   - Compacta e envia todos os logs do diretório para o S3"
	@echo "  make log      - Mostra o log local de uploads"
	@echo "  make clean    - Remove arquivos .tar.gz temporários"
