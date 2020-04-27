# This module simule how a agent make decision of open a door based on a behavior tree.

import random
import time

from behavior_tree import (SelectorTypeNode, SequenceTypeNode, TaskNode,
                           TaskStatus, DecoratorTypeNode)


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
        self.steps = 3 # Steps (distance) to the door

    def run(self):
        if self.steps == 0:
            return TaskStatus.SUCCESS
        else:
            self.steps -= 1
            time.sleep(1)
            print('RUNNING - Walking to the door... (Step {})'.format(self.steps))

            return TaskStatus.RUNNING

class MoveAwayNode(TaskNode):
    """Task in which the agent move away to the door."""
    def __init__(self):
        super(MoveAwayNode, self).__init__()
        self.steps = 3 # Steps (distance) to the door

    def run(self):
        if self.steps == 0:
            return TaskStatus.SUCCESS
        else:
            self.steps -= 1
            time.sleep(1)
            print('RUNNING - Walking away to the door... (Step {})'.format(self.steps))

            return TaskStatus.RUNNING

class CheckNotEnemy(TaskNode):
    """Task in which the agent Look through the window to see if there are not enemies in the sight."""

    def run(self):
        enemy_in_view = bool(random.randint(0, 1))

        if enemy_in_view is not True:
            print("SUCCESS - There aren't enemies in sight")
            result = TaskStatus.SUCCESS
        else:
            print("FAIL - There're enemies in sight")
            result = TaskStatus.FAIL
        return result
   
class AttackEnemy(TaskNode):
    """Task in which the agent attack an enemy."""
    def run(self):
        print('SUCCESS - Ok, the enemy was destroyed')
        return TaskStatus.SUCCESS

def main():

    root = SelectorTypeNode()
    seq = SequenceTypeNode()
    enemy = SelectorTypeNode()
    decorator = DecoratorTypeNode()

    open_door_node = OpenDoorNode()
    check_door_node = CheckDoorNode()
    get_close_node = GetCloseNode()
    move_away_node = MoveAwayNode()
    check_enemy = CheckNotEnemy()
    attack_enemy = AttackEnemy()

    decorator.add_child(attack_enemy)

    enemy.add_child(check_enemy)
    enemy.add_child(decorator)

    seq.add_child(get_close_node)
    seq.add_child(open_door_node)
    seq.add_child(enemy)
    seq.add_child(move_away_node)

    root.add_child(check_door_node)
    root.add_child(seq)

    root.run()


if __name__ == '__main__':
    main()
