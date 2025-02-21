/** virtual button input */

module re.input.virtual.button;

import re.input;
import std.algorithm;

/// a virtual button
class VirtualButton : VirtualInput {
    /// monitors a single button
    static abstract class Node : VirtualInput.Node {
        @property public bool is_down();
        @property public bool is_up();
        @property public bool is_pressed();
        @property public bool is_released();
    }

    /// logic-controllable button
    static class LogicButton : Node {
        public bool logic_pressed = false;
        
        @property public override bool is_down() { return logic_pressed; }
        @property public override bool is_up() { return !logic_pressed; }
        @property public override bool is_pressed() { return logic_pressed; }
        @property public override bool is_released() { return !logic_pressed; }
    }

    /// monitors a keyboard key
    static class KeyboardKey : Node {
        /// the key being monitored
        public Keys key;

        /// creates a keyboard key node
        this(Keys key) {
            this.key = key;
        }

        @property public override bool is_down() {
            return Input.is_key_down(key);
        }

        @property public override bool is_up() {
            return Input.is_key_up(key);
        }

        @property public override bool is_pressed() {
            return Input.is_key_pressed(key);
        }

        @property public override bool is_released() {
            return Input.is_key_released(key);
        }
    }

    @property public bool is_down() {
        return nodes.any!(x => (cast(Node) x).is_down);
    }

    @property public bool is_up() {
        return nodes.any!(x => (cast(Node) x).is_up);
    }

    @property public bool is_pressed() {
        return nodes.any!(x => (cast(Node) x).is_pressed);
    }

    @property public bool is_released() {
        return nodes.any!(x => (cast(Node) x).is_released);
    }
}

@("input-button")
unittest {
    auto the_button = new VirtualButton();
    the_button.nodes ~= new VirtualButton.KeyboardKey(Keys.KEY_E);

    assert(the_button.nodes.length > 0);
}
