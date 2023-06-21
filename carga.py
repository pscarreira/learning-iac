from locust import FastHttpUser, task

class MyUser(FastHttpUser):
  host = "http://127.0.0.1:8000"

  @task
  def index(self):
    self.client.get("/")

