package com.example.todo;

import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/todos")
public class TodoController {
    private final TodoRepository todoRepository;

    public TodoController(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    @GetMapping
    public List<Todo> getAllTodos() {
        return todoRepository.findAll();
    }

    @GetMapping("/{id}")
    public Optional<Todo> getTodoById(@PathVariable Long id) {
        return todoRepository.findById(id);
    }

    @PostMapping
    public Todo createTodo(@RequestBody Todo todo) {
        return todoRepository.save(todo);
    }

    @PutMapping("/{id}")
    public Todo updateTodo(@PathVariable Long id, @RequestBody Todo todoDetails) {
        return todoRepository.findById(id).map(todo -> {
            todo.setTitle(todoDetails.getTitle());
            todo.setCompleted(todoDetails.isCompleted());
            return todoRepository.save(todo);
        }).orElseThrow(() -> new RuntimeException("Todo not found with id " + id));
    }

    @DeleteMapping("/{id}")
    public void deleteTodo(@PathVariable Long id) {
        todoRepository.deleteById(id);
    }
}