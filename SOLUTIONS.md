
# Challenges

## Set up
Preparing the virtual environment:
```
cd the-real-devops-challenge
python3 -m venv venv
source venv/bin/activate
python -m pip install tox
pip install -r requirements.txt
```

Installing Docker for the final challenges: [Docker Official Documentation](https://docs.docker.com/engine/install/ubuntu/#set-up-the-repository)


## Challenge 1

There aren't any instructions on how to create the MongoDB database, so I'm free to choose how to do it. I know there's a free version called MongoDB Atlas, so that's what I'll use for the first challenge.

Once I create my account, the cluster and the collection "restaurant" I proceed to import the data:
```
mongoimport --uri "mongodb+srv://[USERNAME]:[PASSWORD]@cluster0.26oiqds.mongodb.net/restaurant" --collection restaurant --file data/restaurant.json
```

Then proceed to export the MONGO_URI environment variable:
```
export MONGO_URI="mongodb+srv://[USERNAME]:[PASSWORD]@cluster0.26oiqds.mongodb.net/restaurant"
```

### Issues
I try to run the application and I get:


```
ImportError: cannot import name 'JSONEncoder' from 'flask.json' (/home/natalia/pruebas/the-real-devops-challenge/venv/lib/python3.11/site-packages/flask/json/__init__.py)
```

So I need to make a small fix in line #5 of src/mongoflask.py, as the current Python version has its own JSONEncoder.

When it runs, I try to get all of the restaurants I get:

```
[2023-07-13 22:30:37,053] ERROR in app: Exception on /api/v1/restaurant [GET]
Traceback (most recent call last):
  File "/home/natalia/pruebas/the-real-devops-challenge/venv/lib/python3.11/site-packages/flask/app.py", line 2190, in wsgi_app
    response = self.full_dispatch_request()
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/natalia/pruebas/the-real-devops-challenge/venv/lib/python3.11/site-packages/flask/app.py", line 1486, in full_dispatch_request
    rv = self.handle_user_exception(e)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/natalia/pruebas/the-real-devops-challenge/venv/lib/python3.11/site-packages/flask/app.py", line 1484, in full_dispatch_request
    rv = self.dispatch_request()
         ^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/natalia/pruebas/the-real-devops-challenge/venv/lib/python3.11/site-packages/flask/app.py", line 1469, in dispatch_request
    return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/natalia/pruebas/the-real-devops-challenge/app.py", line 20, in restaurants
    return jsonify(restaurants)
           ^^^^^^^^^^^^^^^^^^^^
  File "/home/natalia/pruebas/the-real-devops-challenge/venv/lib/python3.11/site-packages/flask/json/__init__.py", line 170, in jsonify
    return current_app.json.response(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/natalia/pruebas/the-real-devops-challenge/venv/lib/python3.11/site-packages/flask/json/provider.py", line 215, in response
    f"{self.dumps(obj, **dump_args)}\n", mimetype=self.mimetype
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/natalia/pruebas/the-real-devops-challenge/venv/lib/python3.11/site-packages/flask/json/provider.py", line 180, in dumps
    return json.dumps(obj, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/json/__init__.py", line 238, in dumps
    **kw).encode(obj)
          ^^^^^^^^^^^
  File "/usr/lib/python3.11/json/encoder.py", line 200, in encode
    chunks = self.iterencode(o, _one_shot=True)
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/json/encoder.py", line 258, in iterencode
    return _iterencode(o, 0)
           ^^^^^^^^^^^^^^^^^
  File "/home/natalia/pruebas/the-real-devops-challenge/venv/lib/python3.11/site-packages/flask/json/provider.py", line 120, in _default
    raise TypeError(f"Object of type {type(o).__name__} is not JSON serializable")
TypeError: Object of type ObjectId is not JSON serializable
```

In the end, I had to fix way more code than I expected, but it was working correctly now.

## Challenge 2

I have mainly used Jenkins for pipelines, but I didn't think it made sense for this small challenge. Since everything is on GitHub, I thought I'd give GitHub Actions a try. It's my first time using it, so I followed tutorials ([1](https://docs.github.com/en/actions/quickstart),[2](https://www.honeybadger.io/blog/flask-github-actions-continuous-delivery/)) to get started.

In my first attempt, I added the tox test, but it failed. So I ended up removing it from the file to avoid breaking the pipeline.

I included deployment steps for Heroku as an example, but it requires adding credentials, and I'd rather not do that for now.

The executions can be seen [here](https://github.com/natgarea/the-real-devops-challenge/actions/workflows/github-actions.yml).

## Challenge 3

## Challenge 4

## Challenge 5

## Final Challenge