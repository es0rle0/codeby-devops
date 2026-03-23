package ru.codeby;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class AppTest {
    @Test
    void messageIsCorrect() {
        assertEquals("Hello Jenkins!", App.message());
    }
}
