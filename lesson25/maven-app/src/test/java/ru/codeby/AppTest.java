package ru.codeby;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class AppTest {
    @Test
    void greetWorks() {
        assertEquals("Hello, Codeby!", App.greet("Codeby"));
    }
}
