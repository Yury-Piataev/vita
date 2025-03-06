```
ansible-project/
├── hosts.ini
├── playbook.yml
└── roles/
    └── copy/
        ├── tasks/
        │   └── main.yml
        └── files/
            └── example.txt  # Пример файла для копирования

bash/
  └── script.sh

docker-compose/
  └── docker-compose.yml
```

# Ansible-project
### 1. Структура проекта

Создайте следующую структуру каталогов и файлов:
```
ansible-project/
├── hosts.ini
├── playbook.yml
└── roles/
    └── copy/
        ├── tasks/
        │   └── main.yml
        └── files/
            └── example.txt  # Пример файла для копирования
```

### 2. Файл hosts.ini

В этом файле определите группу server и добавьте IP-адреса или имена хостов ваших серверов:
```
[server]
server1 ansible_host=192.168.1.101
server2 ansible_host=192.168.1.102
server3 ansible_host=192.168.1.103

[all:vars]
ansible_user=your_username  # Укажите пользователя для подключения
ansible_ssh_private_key_file=/path/to/your/private/key  # Укажите путь к приватному ключу SSH
```
Замените your_username и /path/to/your/private/key на ваши данные.

### 3. Роль copy

Создайте роль copy, которая будет копировать файлы на сервера.  
Файл roles/copy/tasks/main.yml  
Этот файл содержит задачу для копирования файлов:
```
---
- name: Копирование файлов на сервер
  copy:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner | default(omit) }}"
    group: "{{ item.group | default(omit) }}"
    mode: "{{ item.mode | default(omit) }}"
  loop:
    - { src: "example.txt", dest: "/tmp/example.txt", owner: "root", group: "root", mode: "0644" }
```
Здесь:  
    src — путь к локальному файлу (относительно каталога roles/copy/files/).  
    dest — путь на удаленном сервере, куда будет скопирован файл.  
    owner, group, mode — опциональные параметры для настройки прав и владельца файла. 

### 4. Playbook playbook.yml

Этот файл определяет, какие задачи и роли будут выполнены:
```
---
- name: Копирование файлов на серверы
  hosts: server  # Группа серверов из hosts.ini
  become: yes  # Выполнять задачи с правами суперпользователя
  roles:
    - copy  # Роль для копирования файлов
```

### 5. Запуск Playbook

Перейдите в каталог ansible-project и выполните команду:
```
ansible-playbook -i hosts.ini playbook.yml
```
### Результат  
Файл example.txt из каталога roles/copy/files/ будет скопирован на все сервера из группы server в директорию /tmp/example.txt.  
Права на файл будут установлены в 0644, а владелец и группа — root. 

#### Дополнительные вопросы:  
- Что использовал, и в чем разница with_items от loop?  
Начиная с Ansible 2.8, with_items считается устаревшим (deprecated). В будущих версиях он может быть удален.  
loop лучше т.к. активно развивается и поддерживается, больше опций для контроля выполнения.  
  
- Запустил и что-то не работает как узнать подробнее?   
Увеличить уровень детализации вывода добавлением флагов (ansible-playbook playbook.yml -v):  
-v: базовая информация;  
-vv: детализация + переменные задач;  
-vvv: подключение и отладка;  
-vvvv: максимальная детализация (включая подключение к плагинам).

Проверить статус выполнения задач:  
-обратить внимание на задачи с failed или unreachable в выводе;  
-если задача завершилась с ошибкой, Ansible укажет на это в терминале.  

Проверить логи и состояние сервисов.  

Просмотреть логи приложений.  
    
************************************************************************************************************************************  
  
  
# Bash  
```
#!/bin/bash

# Записываем время начала выполнения скрипта
start_time=$(date +%s)
echo "Скрипт запущен: $(date -d @$start_time '+%Y-%m-%d %H:%M:%S')"

# Директория для поиска логов (измените при необходимости)
LOG_DIR="/var/log"

# Проверка существования директории
if [ ! -d "$LOG_DIR" ]; then
    echo "Ошибка: директория $LOG_DIR не существует!" >&2
    exit 1
fi

# Поиск и подсчёт строк с 'php7.4' во всех файлах директории
total_matches=$(grep -r -w --count 'php7.4' "$LOG_DIR" 2>/dev/null | awk -F: '{sum += $2} END {print sum}')

# Записываем время завершения
end_time=$(date +%s)
echo "Скрипт завершён: $(date -d @$end_time '+%Y-%m-%d %H:%M:%S')"

# Рассчитываем продолжительность
duration=$((end_time - start_time))
echo "Общее время выполнения: $duration секунд"

# Выводим результат поиска
echo "Количество строк с 'php7.4': ${total_matches:-0}"
```

### Как это работает:  
1. Шебанг и время начала
```#!/bin/bash``` указывает на интерпретатор, а start_time сохраняет время старта в секундах.  

2. Поиск в логах  
Ищет слово php7.4 в файлах директории /var/log (можно изменить переменную LOG_DIR):  
grep -r — рекурсивный поиск в поддиректориях.  
-w — точное совпадение слова.  
--count — подсчёт количества совпадений в каждом файле.  
awk суммирует результаты из всех файлов.  

3. Счётчик времени  
Рассчитывает разницу между start_time и end_time.  

4. Вывод результатов  
Все сообщения выводятся в стандартный поток (stdout), а ошибки (например, отсутствие директории) — в stderr.  

### Запуск и сохранение результата  

1. Сделайте скрипт исполняемым:    
```
chmod +x script.sh
```
2. Запустите и сохраните вывод в файл:
```
./script.sh > result.txt
```

*********************************************   


# Docker-compose    

Файл docker-compose.yml
```
version: '3.8'

services:
  nginx:
    image: nginx:1.25
    container_name: nginx
    ports:
      - "1243:80"
    volumes:
      - ./nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf
    networks:
      - vita
    depends_on:
      - php

  php:
    image: php:7.4-fpm
    container_name: php
    volumes:
      - ./:/var/local/sandboxes/dev/www
    environment:
      - PHP_FPM_LISTEN=0.0.0.0:9000
    networks:
      - vita

  postgres:
    image: postgres:15
    container_name: postgres
    environment:
      POSTGRES_PASSWORD: example_password
      POSTGRES_USER: example_user
      POSTGRES_DB: example_db
    networks:
      - vita

networks:
  vita:
    driver: bridge

volumes:
  postgres_data:  # По желанию, для сохранения данных БД
```

Что делает этот файл:  
1. Сеть:
Все контейнеры подключены к сети vita и могут общаться между собой по именам сервисов (nginx, php, postgres).  

3. Nginx:  
Использует версию 1.25;  
Пробрасывает порт 1243 хоста на порт 80 контейнера;  
Монтирует конфиг default.conf из локальной директории;  
Ждёт запуска контейнера php перед стартом.   

4. PHP:  
Использует официальный образ PHP 7.4-FPM;  
Монтирует текущую директорию в контейнер;  
Устанавливает переменную окружения для прослушивания на всех интерфейсах.  

5. Postgres:  
Использует версию 15;  
Задаёт переменные окружения для начальной настройки.  

### Дополнительные нужно настроить Nginx:  
1. Создайте директорию для конфига Nginx:  
```
mkdir -p nginx/conf.d
```
2. Создайте файл nginx/conf.d/default.conf с базовой конфигурацией:
```
server {
    listen 80;
    server_name localhost;
    root /var/local/sandboxes/dev/www;

    location / {
        index index.php index.html;
    }

    location ~ \.php$ {
        fastcgi_pass php:9000;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

## Запуск контейнеров:  
```
docker-compose up -d
```

#### Дополнительные вопросы:  
Если файл default.conf в системе поменяется, изменится ли он внутри контейнера тоже?  
Нужен рестарт при изменении файла default.conf? А если в docker-compose внесли изменения?  

Если файл default.conf изменен на хосте (вне контейнера) зависит от того, как файл подключен к контейнеру  
- если файл монтируется через volumes в docker-compose.yml, то изменения будут сразу видны внутри контейнера без перезапуска, так как это bind mount.  

Но некоторым сервисам (например, Nginx) может потребоваться перезагрузка конфигурации, чтобы изменения вступили в силу:  
```
docker exec -it <container_name> nginx -s reload
```
Или перезапустить все контейнеры:  
```
docker-compose restart
```
Если файл скопирован через COPY в Dockerfile - изменения на хосте не повлияют на контейнер, нужно пересобрать образ и пересоздать контейнер:  
```
docker-compose up -d --build
```
Если изменился docker-compose.yml - требуется перезапуск контейнеров, чтобы изменения применились:  
```
docker-compose up -d
```
Docker Compose определит, какие контейнеры требуют обновления, и пересоздаст их.   
  
-Что нравится больше docker-compose или docker-swarm?  
Docker Compose и Docker Swarm нужны для разных задач.  
Docker Compose - если вы разрабатываете локально или запускаете небольшой сервис на одном сервере. Например: веб-приложение + PostgreSQL + Redis.  
Docker Swarm - если нужно масштабировать сервисы на несколько серверов с балансировкой нагрузки.
Например: высоконагруженный API, где требуется отказоустойчивость.  
Альтернатива Swarm – Kubernetes, если нужна продвинутая оркестрация, гибкость и масштабируемость.

  
