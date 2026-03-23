package ru.codeby;

public class App {
    public static void main(String[] args) {
        System.out.println(greet("Codeby"));
    }
    public static String greet(String name) {
        return "Hello, " + name + "!";
    }
}
