FROM openjdk:17-alpine

WORKDIR /app

COPY App.java /app

RUN javac /app/App.java


# CMD [ "sleep", "2000" ]
ENTRYPOINT [ "java", "App.java" ]