Для установки приложения по инструкции из репозитория https://github.com/anfederico/flaskex нам потребуется установить python3 и pip3:
У меня ubuntu, поэтому команды будут выглядеть таким образом:
```bash
sudo apt install python3-minimal
python3 –V
sudo apt install python3-pip
pip3 install --user --upgrade pip
```
Далее следуем клонируем репозиторий:
```bash
git clone https://github.com/anfederico/Flaskex
```
устанавливаем зависимости:
```bash
cd Flaskex
pip install -r requirements.txt
```
запускаем с помощью:
```bash
python app.py
```
Видим, что корректнее запустить с помощью python3:

```bash
user@test:~/Flaskex$ python app.py
Command 'python' not found, did you mean:
  command 'python3' from deb python3
  command 'python' from deb python-is-python3
user@test:~/Flaskex$ python3 app.py
Traceback (most recent call last):
  File "/home/user/Flaskex/app.py", line 4, in <module>
    from scripts import forms
  File "/home/user/Flaskex/scripts/forms.py", line 6, in <module>
    class LoginForm(Form):
  File "/home/user/Flaskex/scripts/forms.py", line 7, in LoginForm
    username = StringField('Username:', validators=[validators.required(), validators.Length(min=1, max=30)])
AttributeError: module 'wtforms.validators' has no attribute 'required'
```

Гуглим ошибку и выясняем, что в версии v1.0.2 библиотеки WTForms изменился синтаксис и нам нужно исправить модуль нашего приложения. 

Меняем в файле /scripts/forms.py: ```validators.required() на validators.DataRequired()```

```python
class LoginForm(Form):
    username = StringField('Username:', validators=[validators.required(), validators.Length(min=1, max=30)])
    password = StringField('Password:', validators=[validators.required(), validators.Length(min=1, max=30)])
    email = StringField('Email:', validators=[validators.optional(), validators.Length(min=0, max=50)])
```

```python
class LoginForm(Form):
    username = StringField('Username:', validators=[validators.DataRequired(), validators.Length(min=1, max=30)])
    password = StringField('Password:', validators=[validators.DataRequired(), validators.Length(min=1, max=30)])
    email = StringField('Email:', validators=[validators.optional(), validators.Length(min=0, max=50)])
```

Теперь запускаем наше приложение:

```bash
$ python3 app.py
 * Serving Flask app 'app'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://192.168.1.217:5000
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 109-199-816
```

Переходим по ссылке и видим окно логина:

<img src="img/login.jpg">

Теперь упакуем наше приложение в контейнер, чтобы легче его запускать будущем:

```bash
docker build -t alexeiemelin/flask:0.0.2 .
```

И проверим, что контейнер корректно запускается:

```bash
docker run -p 5000:5000 alexeiemelin/flask:0.0.2
```

И загружаем его на hub.docker:
```bash
docker push alexeiemelin/flask:0.0.2
```

https://hub.docker.com/r/alexeiemelin/flask

Завернем наш контейнер в docker-compose.yml и запустим:

```bash
$ docker-compose up
Creating network "flaskex_default" with the default driver
Creating flaskex ... done
Attaching to flaskex
flaskex    |  * Serving Flask app 'app'
flaskex    |  * Debug mode: on
flaskex    | WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
flaskex    |  * Running on all addresses (0.0.0.0)
flaskex    |  * Running on http://127.0.0.1:5000
flaskex    |  * Running on http://172.18.0.2:5000
flaskex    | Press CTRL+C to quit
flaskex    |  * Restarting with stat
flaskex    |  * Debugger is active!
flaskex    |  * Debugger PIN: 922-834-333
flaskex    | 172.18.0.1 - - [05/Apr/2023 07:26:50] "GET / HTTP/1.1" 200 -
flaskex    | 172.18.0.1 - - [05/Apr/2023 07:26:50] "GET /static/css/style.css HTTP/1.1" 304 -
flaskex    | 172.18.0.1 - - [05/Apr/2023 07:26:50] "GET /static/js/scripts.js HTTP/1.1" 304 -
flaskex    | 172.18.0.1 - - [05/Apr/2023 07:26:50] "GET /favicon.ico HTTP/1.1" 404 -

```
