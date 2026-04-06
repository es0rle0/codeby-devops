FROM fluent/fluentd:v1.16-debian-1
USER root

# ВАЖНО: пинним Ruby-клиент Elasticsearch под ES 7.x
RUN gem uninstall -aIx elasticsearch elasticsearch-api elasticsearch-transport elastic-transport || true \
 && gem install elasticsearch -v 7.17.10 --no-document \
 && gem install fluent-plugin-elasticsearch -v 5.4.4 --no-document \
 && gem install fluent-plugin-grok-parser --no-document

COPY fluent.conf /fluentd/etc/fluent.conf
USER fluent
