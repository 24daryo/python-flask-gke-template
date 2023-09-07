# Use the Python 3.11-alpine base image
FROM --platform=linux/amd64 python:3.11-alpine

# Set the environment variables
ENV PYTHONUNBUFFERED True
ENV APP_HOME ./app

# Set the working directory
WORKDIR $APP_HOME

# Copy the application code into the container
COPY . /app

# Copy the requirements file
COPY requirements.txt .

# Upgrade pip and install the Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose the port on which your Flask app will run (if needed)
EXPOSE 5000

# Specify the command to run your Flask app
CMD ["python", "main.py"]
