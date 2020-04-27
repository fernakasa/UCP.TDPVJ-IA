# This module simules how a agent makes decision to open a door based on a behavior tree.

import random
import time

from behavior_tree import (SelectorTypeNode, SequenceTypeNode, TaskNode,
                           TaskStatus)


class CheckDoorNode(TaskNode):
    """Task in which the agent looks if the door is open."""

    def run(self):
        door_is_open = bool(random.randint(0, 1))

        if door_is_open is True:
            print('SUCCESS - Door is already open, I will stay here')
            result = TaskStatus.SUCCESS
        else:
            print('FAIL - Door is closed, I will open it')
            result = TaskStatus.FAIL

        return result


class OpenDoorNode(TaskNode):
    """Task in which the agent opens the door."""
    def run(self):
        print('SUCCESS - Ok, the door is open now :)')
        return TaskStatus.SUCCESS


class GetCloseNode(TaskNode):
    """Task in which the agent gets close to the door."""
    def __init__(self):
        super(GetCloseNode, self).__init__()
        self.steps = 10 # Steps (distance) to the door

    def run(self):
        if self.steps == 0:
            return TaskStatus.SUCCESS
        else:
            self.steps -= 1
            time.sleep(1)
            print('RUNNING - Walking to the door... (Step {})'.format(self.steps))

            return TaskStatus.RUNNING


def main():

    root = SelectorTypeNode()
    seq = SequenceTypeNode()

    open_door_node = OpenDoorNode()
    check_door_node = CheckDoorNode()
    get_close_node = GetCloseNode()

    root.add_child(check_door_node)
    root.add_child(seq)

    seq.add_child(get_close_node)
    seq.add_child(open_door_node)

    root.run()


if __name__ == '__main__':
    main()
